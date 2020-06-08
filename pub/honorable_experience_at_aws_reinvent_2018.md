{{ add_sister }}

@def title = "Honorable Experience @ AWS re:Invent 2018"
@def disqus = true
@def page_id = "354040"
@def rss = "A quick overview about interesting things happened at AWS re:Invent 2018 conference."
@def rss_pubdate = Date(2019, 1, 22)


\blogtitle{Honorable Experience @ AWS re:Invent 2018}
\blogdate{Jan 22, 2019}

The AWS re:Invent conference is one of the largest technology conferences.  I heard over 50,000 people attended the event in 2018.  I was fortunate enough to attend all 5 days, and it’s one of the most rewarding experience for me at a technology conference.

## Workshops, workshops, workshops!
It is a known trick that people attend as many workshops as possible.  Why?  Because they are hands-on with instructors presenting and walking through one or more AWS products.  The instructors are very helpful as they make sure that you understand the subject and you can ask a lot of questions.  In some cases, they will give you a temporary AWS account to play with.  Alternatively, you may use your own personal AWS account for the exercise, and they will give you AWS \$25 credit.

## Honorable Sessions
Some sessions are better than others but I really like the followings.  The speakers really know the material well and led to very clear and concise slides that provoke additional thinkings.  In particular,

* [Big Data Analytics Architectural Patterns and Best Practices](https://www.youtube.com/watch?v=ovPheIbY7U8) (Ben Snively)
* [Building with AWS Databases: Match Your Workload to the Right Database](https://www.youtube.com/watch?v=hwnNbLXN4vA&t=8s) (Rick Houlihan)
* [How HSBC Uses Serverless to Process Millions of Transactions in Real Time](https://www.youtube.com/watch?v=_UiyIJqDXXQ) (Srimanth Rudraraju)
* [Better Analytics Through Natural Language Processing](https://www.youtube.com/watch?v=1khaV-EyPdc) (Nino Bice & Ben Snively)

## Honorable Workshops

### Accelerating Application Development with Amazon Aurora.
I learned about how [Aurora](https://aws.amazon.com/rds/aurora/) works and had a hands-on exercise to set up a new Aorura MySQL cluster, perform backup, and time-travel back to any prior state.  I was hoping for an [Aurora Serverless](https://aws.amazon.com/rds/aurora/serverless/) exercise but the workshop focused on Aurora RDS.  From talking to the instructor, Aurora Serverless is a great service but it is a little behind Aurora MySQL in terms of its features.  On the bright side, because it’s the same code base that AWS develops and maintains, any feature that has been rolled out to Aurora MySQL will probably become availble in the serverless version soon.

### Replicate & Manage Data Using Managed Databases & Serverless Technologies.
I learned to replicate a MySQL database to a SQL Server database using [Data Migration Service](https://aws.amazon.com/dms/) (DMS).  AWS provides a [schema convertion tool](https://aws.amazon.com/dms/schema-conversion-tool/), which allows one to quickly analyze an existing schema and create the same schema on a target database.  While it does not perform 100% of the conversion e.g. triggers or stored procedure are not covered, it still makes the migration a lot easier.  DMS knows how to sync the data from one database to another.  Its ease-of-use really surprised me.

### AWS DeepRacer Workshops – a new, fun way to learn reinforcement learning.
[DeepRacer](https://aws.amazon.com/deepracer/) was the most fun part of the conference as I am quite interested in machine learning technologies.  As part of the workshop, we had a team of 6 people developing the core part of a reinforcement learning algorithm for the toy car – Deep Racer.  By tweaking various parameters (e.g. adjusting steering angle or speed based upon the current position and direction), the machine learns by itself automagically and on the AWS console we can see how well it performs.  Towards the end, everybody cheered when the instructor announced that workshop attendees will to receive a DeepRacer for free.

### Why I like to attend in person?

*Sessions.*  After all, the sessions are [published on YouTube](https://www.youtube.com/user/AmazonWebServices/playlists?shelf_id=33&view=50&sort=dd) and you have the leisure to watch them any time you want, at any speed you want, anywhere.   However, when you attend the sessions, you can ask questions in person.  Or if you are a little shy, you can hear other attendees’ questions and learn from it.  I attended a Data Architecture session, and the speaker was the chief architect for their DynamoDB NoSQL product.  I stayed over 20 minutes after the session, and I felt I learned so much from just listening to all kinds of questions people posted.

*Networking.*  A benefit of attending conferences is that you get to meet people of different background.  At Venetian, I was at a long waiting line for Starbucks. When I waited in line for 20 minutes, I literally spent the whole time chatting with the person in front of me (he’s the main networking guy managing UPenn’s infrastructure) and we continued talking after getting food and coffee.  We finally connected via LinkedIn, finding value in our brand new connection.  At a DeepRacer workshop, I also met a person from Boston University.  We worked as a team in the Reinforcement Learning project and exchanged our work experience.  He was pretty interested in my company’s agile adoption journey 🙂

*Focus.*  Learning is a life long journey.  However, during the work day, I can never find the time to focus on learning something new.  There’s always some other priorities that I have to jump on.  Attending a conference, especially a 5-day one, allows me to forget about work and totally immersed into the sea of AWS products.

*Party.*  I feel that I am least qualified to cite this reason because I don’t really party.  AWS organized quite a few events that would interest other people than me.  Nonetheless, it would still be a good reason to attend.
