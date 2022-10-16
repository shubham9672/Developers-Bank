require('dotenv').config()

const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');

const app = express();

const authRoutes = require('./routes/auth');
const todoRoutes = require('./routes/todo');

app.use(bodyParser.json()); // application/json

app.use((req, res, next) => {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'OPTIONS, GET, POST, PUT, PATCH, DELETE');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
    next();
});

app.use('/auth', authRoutes);
app.use('/todo', todoRoutes);

app.use((err, req, res, next) => {
    console.log(err);
    const status = err.statusCode || 500;
    const msg = err.message;
    res.status(status).json({ message: msg });
})

mongoose.connect(process.env.MONGODB).then(result => {
    const server = app.listen(8080);
    console.log("Connected to DB");
}).catch(err => console.log(err));