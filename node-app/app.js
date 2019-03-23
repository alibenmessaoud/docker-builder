const express = require('express');
const app = express();
const router = express.Router();

const path = __dirname + '/views/';
const port = 8080;

router.use((req, res, next) => {
    console.log('/' + req.method);
    next();
});

router.get('/greeting', (req, res) => {
    res.statusCode = 200;
    res.setHeader('Content-Type', 'text/plain');
    res.end('{"content":"Hello, World!"}');
});

router.get('/', (req, res) => {
    res.statusCode = 200;
    res.setHeader('Content-Type', 'text/html');
    res.sendFile(path + 'index.html');
});

router.get('/sharks', (req, res) => {
    res.statusCode = 200;
    res.setHeader('Content-Type', 'text/html');
    res.sendFile(path + 'sharks.html');
});

app.use(express.static(path));
app.use('/', router);

app.listen(port, () => {
    console.log('Example app listening on port ' + port);
});
