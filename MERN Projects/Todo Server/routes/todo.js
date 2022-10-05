const express = require('express');

const router = express.Router();

const { body } = require('express-validator');


const todoController = require('../controller/todo');
const jwtVerification = require('../middlewares/is-auth');

router.post('/add-todo', body('todo').trim().notEmpty().withMessage("Empty todo"), jwtVerification, todoController.addTodo);

router.put('/change-index', jwtVerification, todoController.changeIndex);

router.post('/get-todos', jwtVerification, todoController.getTodos);

router.put('/update-todo', jwtVerification, todoController.updateTodo);

router.delete('/clear-completed', jwtVerification, todoController.clearCompleted);

module.exports = router;