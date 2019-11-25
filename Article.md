# Firebase - Cloud Firestore

*I spent over a year working on a Cloud Firestore application. I wrote this post to help people understand the power and limitations the Firestore service.*

## What is firebase ?

Firebase Firestore is a cloud* NOSQL database system.  Clients can fetch part of the cloud database to consult on locally, and publish change that will be reflected almost instantly to other clients through the cloud master.

You could for exemple implement an app with a live drawing board or a chat where every new user input is a new row in a database, with changes  reflected in real time to all users.

 \* : You can use the firebase 100% locally and without cloud sync, but it’s not what we are going to talk about.

Here is a quick demo of two iOS apps sharing the same textfield through firebase

[XXX GitHub link, video]

Disclaimer: the codes exemples are in Swift but Firestore is available on many other languages/platforms through a similar API.

## Quick look into the API

### Data structures

Firebase requires you to represent data into collections and documents.
In effect the database can be represented into a single JSON.
If you come from a relational world, this will force you to rethink the way you establish relationships.

Keeping the data integrity is entirely up to the developer (altho there are tools to help you with this), and lot of the logic that used to be guaranteed by the database/serverside is going to be entirely in your hands.

One good exemple is that `DocumentReference`  can be stored, but unlike a SQL `ForeignKey`, it is not going to be nullified if the document pointed to is removed.  `DocumentReference`  are in fact simple URLS

### Code exemple

* Do a one time fetch

```
    Firestore.firestore() // Access the database
       .collection("aCollection") // With collection ID "aCollection"
       .document("aDocument") // With document ID "aDocument"
       .getDocument { (<#DocumentSnapshot?#>, <#Error?#>) in
            Your document XOR an error
        }
```

* Create a listener, to fetch data and be notified about any changes, in real time.

```
    Firestore.firestore() // Access the database
       .collection("aCollection") // With collection ID "aCollection"
       .document("aDocument") // With document ID "aDocument"
       .addSnapshotListener { (<#DocumentSnapshot?#>, <#Error?#>) in
            Your updated document XOR an error
        }

```

As long as the  `ListenerRegistration` returned by `addSnapshotListener`  is retained, updates will be published to the callback.

You can observe any fetch request,  (queries, collections changes, documents changes, …)

## Triggers and Web functions

Firebase have a `Function` tool. It works similarly to amazon lambda, and comes preloaded with Firebase/Firstore support.

Functions are written in NodeJS, and can be called either directly from a REST API, using the function SDK, or from a database trigger.

Database triggers are: `onWrite` `onCreate` `onUpdate` `onDelete`

Some common use cases could be:

- Generating a thumbnail
- Sending a notification/email
- Removing reference to deleted objects
- Updating reciprocal values (it’s sometime easier/faster to duplicate data across the DB due to the inherent limitations of NOSQL)

## Limitations and pitfalls

#### No `OR` Query

One of the most striking limitation I found with firebase was the absence of an `OR` or similar search keyword. It’s probably a performance tradeoff, so it’s unlikely this will be added in the future. The database is just not designed to be run this way.

You are left with two solutions:

- Run multiple queries
- Use an external database, such as elastic search.

#### Errors happen !

While it can be tempting to ignore the error parameter provided by firebase (and might even be fine for a prototype), be warned that error WILL happen. They will also happen where you might not have expected them, such as when accessing the database on a server side triggers. You can use batch operation and commits to guarantee to guard against partial failures, but it will require you to have some thoughtful design.

#### The firebase SDK updates for iOS can be buggy

I am not sure about the other platforms but I encountered a few crash (including one that required the affected users to reinstall the app) by updating the SDK to a defective version. I suggest to pin a version and upgrade carefully.

## Conclusion

Firebase is an awesome tool. It allows you to implement in minutes things that would have required months of years of man hours before. There are however a few limitations to it, and I hope you now understand it better!
