# Install the MongoDB driver package from NuGet
Install-Package -Name MongoDB.Driver -Source NuGet.org -Force

# MongoDB connection string for MongoDB Atlas
$mongoConnectionString = "mongodb+srv://klausm1024:R16BZkWn2HZQAzD7@cluster0.uq9lhec.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0"

# Define the MongoDB database and collection name
$databaseName = "keylog"
$collectionName = "users"

# Function to connect to MongoDB Atlas
function ConnectToMongoDB {
    param (
        [string]$connectionString
    )

    # Connect to MongoDB Atlas
    $mongoClient = New-Object -TypeName MongoDB.Driver.MongoClient -ArgumentList $connectionString

    return $mongoClient
}

# Connect to MongoDB Atlas
$mongoClient = ConnectToMongoDB -connectionString $mongoConnectionString

# Define a function to insert a document into a MongoDB collection
function InsertDocument {
    param (
        [MongoDB.Driver.IMongoClient]$client,
        [string]$dbName,
        [string]$collectionName,
        [Hashtable]$document
    )

    # Get the database and collection
    $database = $client.GetDatabase($dbName)
    $collection = $database.GetCollection($collectionName)

    # Insert document into MongoDB collection
    $collection.InsertOne($document)
}

# Define a sample document to insert into the collection
$sampleDocument = @{
    "name" = "John Doe"
    "age" = 30
    "email" = "john.doe@example.com"
}

# Insert the sample document into the specified collection
InsertDocument -client $mongoClient -dbName $databaseName -collectionName $collectionName -document $sampleDocument

Write-Host "Document inserted successfully into the collection '$collectionName' in database '$databaseName'."

