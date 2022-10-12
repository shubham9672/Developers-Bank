const jwt = require('jsonwebtoken');

module.exports = (req, res, next) => {
    const authHeader = req.get("Authorization");
    if (!authHeader) {
        const error = new Error("Invalid authorization header");
        error.statusCode = 401;
        throw error;
    }

    const token = authHeader.split(' ')[1];
    const decodedToken = jwt.verify(token, "thisistopsecretkey", (err, decoded) => {
        if (err) {
            const error = new Error(err);
            error.statusCode = 403;
            throw error;
        }

        return decoded;
    });
    if (!decodedToken) {
        const error = new Error("Invalid token");
        error.statusCode = 403;
        throw error;
    }
    req.userId = decodedToken.userId;
    req.name = decodedToken.userName;
    req.lightMode = decodedToken.isLightMode;
    next();
};