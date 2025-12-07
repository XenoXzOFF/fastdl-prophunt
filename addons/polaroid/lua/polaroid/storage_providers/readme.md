# Polaroid storage providers

Why and how it works?

## Why not store photos on the server side?

We believe that addons should not affect the server performance, if possible.  
All heavy processes should be implemented using external services.
There is 3 reasons why we doesn't use server io for photos hosting:

1. This is an waste of server disk space.
2. This is waste of server io/networking.
3. Net lib is not designed to send large data, there is limits like 64kb per message, 256kb buffer size, e.t.c

## How to make storage provider?

You can create storage provider for any filehost - eg pomf, chibisafe, e.t.c  
Its pretty easy to make, even chatgpt can make it.
All things you need to know:

### Properties

`number` maxFileSize - bytes number, script will reduce photo quality if data size out of limits.  
`boolean` encode - should script use base64 encoding? its useful if service accepts only string data.

### Methods

#### Provider:Upload(image, onSuccess, onFailure)

Uploads image to host, if success call onSuccess with unique id, if failure call onFailure with reason.  
Script will retry 3 times if failed.

---

#### Provider:GetURL(uid)

returns photo url, eg `L5D6qLP` > `https://i.imgur.com/L5D6qLP.jpeg`

---

#### Provider:Download(uid, onSuccess, onFailure)

Downloads image, if success call onSuccess with body, if failure call onFailure with reason.  
Script will retry 3 times if failed.  
Script performs downloads sequentially, instead of parallel - so GET ratelimits shouldnt be a problem.
