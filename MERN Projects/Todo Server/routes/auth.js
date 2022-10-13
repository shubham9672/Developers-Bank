const express = require('express');
const { body } = require('express-validator');
const userSchema = require('../model/User');
const jwtVerification = require('../middlewares/is-auth');

const router = express.Router();

const authController = require('../controller/auth');

router.post('/signup',
    body('email').trim().notEmpty().isEmail().withMessage("Invalid email").custom(value => userSchema.findOne({ email: value }).then(user => (user ? Promise.reject("Email already exist") : null))),
    body('name').trim().notEmpty().custom(value => value.includes(' ')).withMessage("Invalid full name"),
    authController.signUp);

router.post('/login', authController.login);

router.put('/update-user', jwtVerification, body('email').trim().notEmpty().isEmail().withMessage("Invalid email"), authController.updateUser);

router.post('/verify', jwtVerification, authController.authentication);

router.get('/website', jwtVerification, authController.websiteSettng);

module.exports = router;