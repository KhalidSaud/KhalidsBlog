# Khalid's Blog

This is a personal blog made as a Udacity project, this personal app has one author, and the author can manage simple blogs list where he can add a blog including a Ttile, An Image and Content, also it can be edited and deleted.

Guest user can access the app contents and read the blogs, only blog author can access aditinal features (Add/Edit/Delete)

Temporary login credentials:-

Email : udacity@udacity.com
password: password

# API

Khalid's Blog App is connected to a custom made API, although it was not part of the project requirments, we spent our time to create this API aiming to increase personal skill for a brighter future.
API is made with ASP.NET Core 2.1, Entity Framewrok and SQL Server.
API is connected to a personal Server.

# API Endpoints

Get request all blogs : "https://myblogapi.khalidsaud.com/api/blogs"
Response : 
[
    {
        "id": 17,
        "title": "Flowers 3",
        "imageName": "065e20fc-be55-4b83-b920-deeb0501cb62.jpg",
        "content": "Content about flowers"
    }
]

Post request : "https://myblogapi.khalidsaud.com/api/blogs"
Response : 
    {
        "id": 17,
        "title": "Flowers 3",
        "imageName": "065e20fc-be55-4b83-b920-deeb0501cb62.jpg",
        "content": "Content about flowers"
    }
    
Put request : "https://myblogapi.khalidsaud.com/api/blogs"
Response: No Content

Delete request : "https://myblogapi.khalidsaud.com/api/blogs/{blogId}"
Response : 
    {
        "id": 17,
        "title": "Flowers 3",
        "imageName": "065e20fc-be55-4b83-b920-deeb0501cb62.jpg",
        "content": "Content about flowers"
    }

Get request blog's image : "https://myblogapi.khalidsaud.com/api/image/{imageName}"
response : 200 OK with attached image.

POST login : "https://myblogapi.khalidsaud.com/api/auth"
Response : 
{
    "id": 2,
    "email": "udacity@udacity.com",
    "password": "password"
}