import { createContext, useContext, useState } from "react";

const NodeContext = createContext();

export const useNodeContext = () => useContext(NodeContext);

export default function Context(props) {
    const [isAuthenticated, setIsAuthenticated] = useState(null);
    const [userName, setUserName] = useState(null);
    const [userId, setUserId] = useState(null);
    const [isLogin, setIsLogin] = useState(false);
    const [todo, setTodo] = useState([]);
    const [isLightMode, setIsLightMode] = useState(true);


    const loginHandler = (token, userName, userId) => {
        localStorage.setItem('token', token);
        setUserName(userName);
        setIsAuthenticated(true);
        setUserId(userId);
    };

    const logoutHandler = () => {
        if (localStorage.getItem("token")) localStorage.removeItem("token");
        setIsAuthenticated(false);
    };

    const changeMode = () => {
        setIsLightMode(!isLightMode);
    }

    return (
        <NodeContext.Provider value={{
            login: { loginHandler },
            logout: { logoutHandler },
            auth: isAuthenticated,
            name: userName,
            setAuth: { setIsAuthenticated },
            setUserName: { setUserName },
            setUserId: { setUserId },
            userId: userId,
            loginStatus: isLogin,
            setLoginstatus: { setIsLogin },
            todo: todo,
            setTodo: { setTodo },
            setMode: { changeMode },
            changeMode: { setIsLightMode },
            mode: isLightMode
        }}>
            {props.children}
        </NodeContext.Provider>
    );
};