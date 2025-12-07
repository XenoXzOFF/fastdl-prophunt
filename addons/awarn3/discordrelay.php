<?php
declare(strict_types=1);

/**
 * AWarn3 → Discord Relay
 * - Validates inputs (method, URL, log type, color)
 * - Deduplicates embed construction
 * - Truncates fields to Discord limits
 * - Adds cURL timeouts + error reporting
 * - Returns proper HTTP codes on errors
 */

// ---------- helpers ----------
function bad_request(string $msg, int $code = 400): never {
    http_response_code($code);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode(['ok' => false, 'error' => $msg], JSON_UNESCAPED_SLASHES);
    exit;
}

function trunc(?string $s, int $max): string {
    $s = (string)($s ?? '');
    if (mb_strlen($s, 'UTF-8') <= $max) return $s;
    // reserve 1 char for the ellipsis
    return mb_substr($s, 0, $max - 1, 'UTF-8') . '…';
}

function hex_color_to_int(?string $hex): int {
    $hex = (string)$hex;
    // Accept forms like "FFAABB" or "#FFAABB"
    $hex = ltrim($hex, "#");
    if (!preg_match('/^[0-9A-Fa-f]{6}$/', $hex)) {
        // Default to Discord blurple if invalid
        return hexdec('5865F2');
    }
    return hexdec($hex);
}

// ---------- request validation ----------
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    bad_request('POST required', 405);
}

$logType = $_POST['log_type'] ?? null;
$webhookUrl = $_POST['url'] ?? null;

if (!$logType || !$webhookUrl) {
    bad_request('Missing required fields: log_type, url');
}

if (!in_array($logType, ['warning', 'punishment'], true)) {
    bad_request('Invalid log_type (expected "warning" or "punishment")');
}

if (!filter_var($webhookUrl, FILTER_VALIDATE_URL)) {
    bad_request('Invalid webhook URL');
}

// ---------- constants / limits ----------
$USERNAME    = 'AWarn3 Logs';
$AVATAR_URL  = 'https://g4p.org/awarn2/awarn3_chatlogo.png';
$FOOTER_TEXT = 'AWarn3 Discord Relay';
$FOOTER_ICON = $AVATAR_URL;

// Discord embed limits (core ones we touch)
$LIMITS = [
    'title'      => 256,
    'field_name' => 256,
    'field_val'  => 1024,
];

// ---------- build embed ----------
$timestamp = date('c'); // ISO8601

$title     = trunc($_POST['title'] ?? '', $LIMITS['title']);
$colorInt  = hex_color_to_int($_POST['bar_color'] ?? null);

$fields = [];

if ($logType === 'warning') {
    $fields[] = [
        'name'   => trunc('Warned Player', $LIMITS['field_name']),
        'value'  => trunc($_POST['warned_player'] ?? 'Unknown', $LIMITS['field_val']),
        'inline' => true,
    ];
    $fields[] = [
        'name'   => trunc('Warning Admin', $LIMITS['field_name']),
        'value'  => trunc($_POST['warning_admin'] ?? 'Unknown', $LIMITS['field_val']),
        'inline' => true,
    ];
    $fields[] = [
        'name'   => trunc('Warning Reason', $LIMITS['field_name']),
        'value'  => trunc($_POST['warning_reason'] ?? 'None provided', $LIMITS['field_val']),
        'inline' => false,
    ];
} else { // punishment
    $fields[] = [
        'name'   => trunc('Punished Player', $LIMITS['field_name']),
        'value'  => trunc($_POST['punished_player'] ?? 'Unknown', $LIMITS['field_val']),
        'inline' => true,
    ];
    $fields[] = [
        'name'   => trunc('Player Warnings', $LIMITS['field_name']),
        'value'  => trunc($_POST['player_warnings'] ?? '0', $LIMITS['field_val']),
        'inline' => true,
    ];
    $fields[] = [
        'name'   => trunc('Punishment', $LIMITS['field_name']),
        'value'  => trunc($_POST['punishment'] ?? 'None applied', $LIMITS['field_val']),
        'inline' => false,
    ];
}

$payload = [
    'content'   => '',
    'username'  => $USERNAME,
    'avatar_url'=> $AVATAR_URL,
    'embeds'    => [[
        'title'     => $title,
        'type'      => 'rich',
        'timestamp' => $timestamp,
        'color'     => $colorInt,
        'footer'    => [
            'text'     => $FOOTER_TEXT,
            'icon_url' => $FOOTER_ICON,
        ],
        'fields'    => $fields,
    ]],
];

$json = json_encode($payload, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
if ($json === false) {
    bad_request('Failed to encode JSON payload');
}

// ---------- send to Discord ----------
$ch = curl_init($webhookUrl);
curl_setopt_array($ch, [
    CURLOPT_HTTPHEADER     => ['Content-Type: application/json'],
    CURLOPT_POST           => true,
    CURLOPT_POSTFIELDS     => $json,
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_FOLLOWLOCATION => true,
    CURLOPT_CONNECTTIMEOUT => 5,
    CURLOPT_TIMEOUT        => 10,
    CURLOPT_USERAGENT      => 'AWarn3-DiscordRelay/1.0',
]);

$response = curl_exec($ch);
$errno    = curl_errno($ch);
$error    = curl_error($ch);
$code     = (int)curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

// ---------- respond ----------
header('Content-Type: application/json; charset=utf-8');
if ($errno !== 0) {
    bad_request('cURL error: ' . $error, 502);
}

if ($code < 200 || $code >= 300) {
    // Discord often returns 204 on success; anything else we surface
    bad_request('Discord returned HTTP ' . $code . ' ' . $response, 502);
}

echo json_encode(['ok' => true, 'status' => $code], JSON_UNESCAPED_SLASHES);
