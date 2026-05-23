The application itself is the coordinator. MongoDB does not talk directly to Redis or to the user; your application's backend code is entirely responsible for passing the queries back and forth.

### The Cache Miss Data Flow
```
[User / Client]             [Application Backend]            [Redis Cache]           [MongoDB]
       │                               │                           │                     │
       │ 1. GET /products/123          │                           │                     │
       ├──────────────────────────────►│                           │                     │
       │                               │ 2. Check key 'product:123'│                     │
       │                               ├──────────────────────────►│                     │
       │                               │ 3. Returns null (Miss)    │                     │
       │                               │◄──────────────────────────┤                     │
       │                               │                                                 │
       │                               │ 4. Query document by ID                         │
       │                               ├────────────────────────────────────────────────►│
       │                               │ 5. Returns Product Document                     │
       │                               │◄────────────────────────────────────────────────┤
       │                               │                                                 │
       │                               │ 6. SetEx 'product:123' (Save for next time)     │
       │                               ├──────────────────────────►│                     │
       │ 7. Sends Product Data JSON    │                           │                     │
       │◄──────────────────────────────┤                           │                     │
```
### Step-by-Step Breakdown
1. The Request: The user triggers an action (e.g., clicking on a product page), which sends an HTTP request to your Node.js/Express application backend.
2. The  Cache Check: Your backend intercepts this request and asks Redis: "Do you have data for product:123?"
3. The Cache Miss: Redis searches its RAM, finds nothing, and returns null or undefined to your backend.
4. The Database Query: Because Redis returned nothing, your backend application explicitly makes a database call to MongoDB using a driver (like Mongoose) asking for that specific product ID.
5. The Database Response: MongoDB reads the data from the disk and sends the raw document back to your backend application.
6. The Cache Populate: Your backend application takes that data, stringifies it, and saves a copy inside Redis with a Time-To-Live (TTL) so that the next request will be a cache hit.
7. The Final Delivery: Your backend application formats the data into a JSON response and sends it back out to the user's browser.

8. 💡 Architect Note: Neither database knows the other one exists. MongoDB is completely unaware that Redis is caching its data, and Redis is completely unaware that the data originally came from MongoDB. Your backend application acts as the "brain" or the bridge connecting them together.
