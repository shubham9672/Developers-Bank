const path = require('path');
const express = require("express");
const http = require('http');
const socketio = require('socket.io');
const { emit } = require('process');
const formatMessage = require('./utils/messages');
const { userJoin, getUser, userLeave, getRoomUser } = require('./utils/user');

const app = express();
const server = http.createServer(app);
const io = socketio(server);

//Set Static Folder
app.use(express.static(path.join(__dirname, 'public')));

const botName = "I am Bot";

//Run When Client Connects
io.on('connection', socket => {
    console.log("New Connection...");
    socket.on('joinRoom', ({ username, room }) => {
        const user = userJoin(socket.id, username, room);
        socket.join(user.room);

        socket.emit('message', formatMessage(botName, 'Welcome to Chatchord...'));

        //Braoadcast when user connects
        socket.broadcast.to(user.room).emit('message', formatMessage(botName, `${user.username} has joined the room`));

        //send users info 
        io.to(user.room).emit('roomUsers', {
            room: user.room,
            users: getRoomUser(user.room)
        })

        //listen for chat msg
        socket.on('chatMessage', (msg) => {
            const user = getUser(socket.id);
            io.to(user.room).emit('message', formatMessage(`${user.username}`, msg));
            // console.log(msg);
        })

        //runs when client disconnects
        socket.on('disconnect', () => {

            const user = userLeave(socket.id);

            if (user) {
                io.to(user.room).emit('message', formatMessage(botName, `${user.username} has left the room`))

                //send users info 
                io.to(user.room).emit('roomUsers', {
                    room: user.room,
                    users: getRoomUser(user.room)
                })
            };

        });

    });
});

const PORT = 3000 || process.env.PORT;
server.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
