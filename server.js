const http = require('http');

// Define the port to listen to
const PORT = 3000;

// Define the HTML content
const htmlContent = `
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Node.js Server</title>
</head>
<body>
  <h1>Hello, this is your Node.js server!</h1>
</body>
</html>
`;

// Create the server
const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/html');
  res.end(htmlContent);
});

// Make the server listen on the specified port
server.listen(PORT, () => {
  console.log(`Server is listening on port ${PORT}`);
});

