const mongoose = require('mongoose');

const Schema = mongoose.Schema;

const todoSchema = new Schema({
    todo: {
        type: String,
        required: true,
    },
    index: {
        type: Number,
        required: true
    },
    isCompleted: {
        type: Boolean,
        required: true
    },
    userId: {
        type: Schema.Types.ObjectId,
        required: true
    }
}, { timestamps: true });

module.exports = mongoose.model('todo', todoSchema);