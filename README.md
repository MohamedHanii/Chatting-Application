# Chat Application

App that allow creating new applications where each application will have a token(generated by the system) and a name(provided by the client).
The token is the identifier that devices use to send chats to that application.

Each application can have many chats, a chat have a number, Numbering of chats in each application starts from 1 and no 2 chats in the same application.

A chat contains messages and messages have numbers that start from 1 for each chat. The client identifies the application by its token and the chat by
its number along with the application token.

Client can search through messages of a specific chat. they are able to partially match messages’ bodies.


## Application Setup Instructions

You need only docker for setup the application [Docker](https://docs.docker.com/engine/install/ubuntu/)

After installing docker you can write thses commands to run the application

Clone Repository

```
git clone https://github.com/MohamedHanii/Chatting-Application.git
```

Running Application

```
cd Chatting-Application

sudo docker-compose up --build
```
## Database Design
The application have 3 tables: Applications, Chats, Messages with 1-M Relationship between Applications and Chats and 1-M Relationship between Chats and Messages

**Applications Table**

| Field      | Type             | Null  | Key   | Default | Extra          |
|:-----------|:-----------------|:------|:------|:--------|:---------------|
| id         | int(11)          | NO    | PRI   | NULL    | auto_increment |
| token      | varchar(255)     | YES   |       | NULL    |                |
| name       | varchar(255)     | YES   |       | NULL    |                |
| chatCount  | decimal(10,0)    | YES   |       | 0       |                |
| created_at | datetime         | NO    |       | NULL    |                |
| updated_at | datetime         | NO    |       | NULL    |                |


**Chats Table**

| Field          | Type          | Null | Key   | Default | Extra          |
|:---------------|:--------------|:-----|:------|:--------|:---------------|
| id             | int(11)       | NO   | PRI   | NULL    | auto_increment |
| chatName       | varchar(255)  | YES  |       | NULL    |                |
| chatNumber     | decimal(10,0) | YES  |       | NULL    |                |
| messageCount   | decimal(10,0) | YES  |       | 0       |                |
| application_id | int(11)       | YES  |       | NULL    |                |
| created_at     | datetime      | NO   |       | NULL    |                |
| updated_at     | datetime      | NO   |       | NULL    |                |


**Messages Table**

| Field          | Type             | Null  | Key | Default | Extra          |
|:---------------|:-----------------|:------|:----|:--------|:---------------|
| id             | int(11)          | NO    | PRI | NULL    | auto_increment |
| messageContent | varchar(255)     | YES   |     | NULL    |                |
| messageNumber  | decimal(10,0)    | YES   |     | NULL    |                |
| chat_id        | int(11)          | YES   |     | NULL    |                |
| created_at     | datetime         | NO    |     | NULL    |                |
| updated_at     | datetime         | NO    |     | NULL    |                |



## Immplmentation

As first, i started with created dockerfile and docker-compose file which have the following containers:
* db        --> MYSQL
* sidekiq   --> Queue System
* es        --> Elastic Search
* redis     --> In Memory database (Redis)
* app       --> Ruby on Rails

The API implemenetd using Rails V5 along with MYSQL as database while having Redis as in memory database for keeping track of the counts of chats and messages created.

Using Sidekiq as job scheduler to run sidekiq job every 15 mints to update the chats and message counts that storge in Redis, also used Sidekiq as Queue System to avoid avoid writing directly to MySQL while serving the requests(especially for the chats and messages creation endpoints).

Using Elastic Search to be able to search among messages with a given keyword (Partial matching). 



## API Endpoints

API is running and listening on port 3001

### Application Endpoints
**Get all Application**   [GET /api/v1/applications]

```
curl -X GET  http://localhost:3001/api/v1/applications
```

response:

```
[
    {
        "token": "2b579d089f",
        "name": "test application",
        "chatCount": 1,
        "created_at": "2022-05-30T13:27:03.000Z",
        "updated_at": "2022-05-30T13:59:04.000Z"
    },
    {
        "token": "bf572e5acd26bc9c",
        "name": "test application#2",
        "chatCount": 0,
        "created_at": "2022-05-31T13:36:36.000Z",
        "updated_at": "2022-05-31T13:36:36.000Z"
    }
]
```

**Get Specific application using application token** [GET /api/v1/applications/:token]

```
 curl -X GET  http://localhost:3001/api/v1/applications/bf572e5acd26bc9c
```

response: 

```
{
    "token": "bf572e5acd26bc9c",
    "name": "test application#2",
    "chatCount": 0,
    "created_at": "2022-05-31T13:36:36.000Z",
    "updated_at": "2022-05-31T13:36:36.000Z"
}
```

**Create new application**  [POST /api/v1/applications]

```
curl -X POST  http://localhost:3001/api/v1/applications?name=test-application
```

response:

```
{
  "token":"d42ad2ff1955ebe6",
  "name":"test-application",
  "chatCount":0,
  "created_at":"2022-06-02T08:57:21.000Z",
  "updated_at":"2022-06-02T08:57:21.000Z"
 }
```

**Update Application using token** [PUT /api/v1/applications/:token]

```
curl -X PUT  http://localhost:3001/api/v1/applications/d42ad2ff1955ebe6?name=updated-application
```

response:

```
{
  "name": "updated-application",
  "token": "d42ad2ff1955ebe6",
  "chatCount": 0,
  "created_at": "2022-06-02T08:57:21.000Z",
  "updated_at": "2022-06-02T09:00:14.000Z"
}
```

**Delete Application using token** [DELETE /api/v1/applications/:token]

```
curl -X DELETE  http://localhost:3001/api/v1/applications/d42ad2ff1955ebe6
```

response:

```
{
  "token": "d42ad2ff1955ebe6",
  "name": "updated-application",
  "chatCount": 0,
  "created_at": "2022-06-02T08:57:21.000Z",
  "updated_at": "2022-06-02T09:00:14.000Z"
}
```

### Chat Endpoints
**Get all Chats for application using application Token**   [GET /api/v1/applications/:token/chats]

```
curl -X GET  http://localhost:3001/api/v1/applications/bf572e5acd26bc9c/chats
```

response:

```
[
  {
    "chatName": "first Chat",
    "chatNumber": 1,
    "messageCount": 0,
    "created_at": "2022-06-02T09:06:18.000Z",
    "updated_at": "2022-06-02T09:06:18.000Z"
  },
  {
    "chatName": "second Chat room",
    "chatNumber": 2,
    "messageCount": 0,
    "created_at": "2022-06-02T09:06:26.000Z",
    "updated_at": "2022-06-02T09:06:26.000Z"
  }
]
```

**Get Specific Chat using application token and Chat Number** [GET /api/v1/applications/:token/chats/:chatNumber]

```
 curl -X GET  http://localhost:3001/api/v1/applications/bf572e5acd26bc9c/chats/1
```

response: 

```
{
  "chatName": "first Chat",
  "chatNumber": 1,
  "messageCount": 0,
  "created_at": "2022-06-02T09:06:18.000Z",
  "updated_at": "2022-06-02T09:06:18.000Z"
}
```

**Create new Chat**  [POST /api/v1/applications/:token/chats]

```
curl -X POST  http://localhost:3001/api/v1/applications/bf572e5acd26bc9c/chats?name=test-application
```

response:

```
{
  "chatName": "test-application",
  "chatNumber": 3,
  "messageCount": 0,
  "created_at": null,
  "updated_at": null
}
```

**Update Chat using application token with chat number** [PUT /api/v1/applications/:token/chats/:chatNumber]

```
curl -X PUT  http://localhost:3001/api/v1/applications/bf572e5acd26bc9c/chats/1?name=updated-chat
```

response:

```
{
  "chatName": "updated-chat",
  "chatNumber": 1,
  "messageCount": 0,
  "created_at": "2022-06-02T09:06:18.000Z",
  "updated_at": "2022-06-02T09:12:38.000Z"
}
```

### Message Endpoints
**Get all Messages for chat using application token and chat number**   

[GET /api/v1/applications/:token/chats/:chatNumber/messages]

```
curl -X GET  http://localhost:3001/api/v1/applications/567493619db03f60/chats/3/messages
```

response:

```
[
    {
        "messageContent": "first message",
        "messageNumber": 1,
        "created_at": "2022-06-01T10:25:19.000Z",
        "updated_at": "2022-06-01T10:25:19.000Z"
    },
    {
        "messageContent": "first message",
        "messageNumber": 2,
        "created_at": "2022-06-01T10:26:16.000Z",
        "updated_at": "2022-06-01T10:26:16.000Z"
    },
    {
        "messageContent": "first message",
        "messageNumber": 3,
        "created_at": "2022-06-01T10:47:21.000Z",
        "updated_at": "2022-06-01T10:47:21.000Z"
    }
]
```

**Get Specific Message using application token and chat number and message number** 

[GET /api/v1/applications/:token/chats/:chatNumber/messages/:messageNumber]

```
 curl -X GET  http://localhost:3001/api/v1/applications/567493619db03f60/chats/3/messages/1
```

response: 

```
{
    "messageContent": "first message",
    "messageNumber": 1,
    "created_at": "2022-06-01T10:25:19.000Z",
    "updated_at": "2022-06-01T10:25:19.000Z"
}
```

**Create new Message**  

[POST /api/v1/applications/:token/chats/:chatNumber/messages]

```
curl -X POST  http://localhost:3001/api/v1/applications/bf572e5acd26bc9c/chats/3/messages?message=test-message
```

response:

```
{
  "messageContent": "test-message",
  "messageNumber": 2,
  "created_at": null,
  "updated_at": null
}
```

**Update message using application token with chat number and message number** 

[PUT /api/v1/applications/:token/chats/:chatNumber/messages/:messageNumber]

```
curl -X PUT  http://localhost:3001/api/v1/applications/bf572e5acd26bc9c/chats/3/messages/1?message=updated-chat
```

response:

```
{
  "messageContent": "updated-chat",
  "messageNumber": 1,
  "created_at": "2022-06-02T09:24:13.000Z",
  "updated_at": "2022-06-02T09:27:35.000Z"
}
```

**Search Through Messages** 
[GET /api/v1/applications/messages/search?query=]

```
curl -X GET  http://localhost:3001/api/v1/applications/messages/search?query=New
```

response:

```
[
  {
    "messageContent": " New Message",
    "messageNumber": 3
  },
  {
    "messageContent": " New Created Message",
    "messageNumber": 4
  }
]
```

## Future Work

* Create the endpoints of chats and messages creation as a Golang app.
* Use RabbitMQ as queuing system instead of Sidekiq.
 
