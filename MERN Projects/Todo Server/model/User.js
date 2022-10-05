const mongoose = require('mongoose');

const Schema = mongoose.Schema;

const userSchema = new Schema({
    name: {
        type: String,
        required: true
    }, 
    email: {
        type: String,
        required: true
    },
    password: {
        type: String,
        required: true
    },
    isLightMode: {
        type: Boolean,
        default: true
    }
});

module.exports = mongoose.model("Users", userSchema);