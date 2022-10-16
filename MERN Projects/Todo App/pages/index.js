import Head from 'next/head'
import Header from '../components/Header'
import TodoList from '../components/TodoList'
import Profile from '../components/Profile'
import Setting from '../components/Settings'
import { useEffect, useState } from 'react';
import { useNodeContext } from '../context/nodes/NodeContext'
import Router from 'next/router'
import axios from 'axios'

export default function Home() {
  const ctx = useNodeContext();
  // const [isLightMode, setIsLightMode] = useState(true);
  const [showCredentials, setShowCredentials] = useState(false);
  const [isLoading, setIsLoading] = useState(null);

  useEffect(() => {
    if (localStorage.getItem("token") && !ctx.loginStatus) {
      axios.post('https://todo-sv.vercel.app/auth/verify', {}, {
        headers: {
          "Authorization": `Bearer ${localStorage.getItem("token")}`
        }
      }).then(res => {
        if (!res.data?.isAuth) Router.push("/login");
        else {
          // console.log(res.data);
          ctx.setAuth.setIsAuthenticated(true);
          ctx.setUserName.setUserName(res.data.name);
          ctx.setUserId.setUserId(res.data.userd);
          ctx.changeMode.setIsLightMode(res.data.lightMode);
        }
      }).catch(err => {
        console.error(err);
      })
    } else {
      if (ctx.auth !== true) Router.push("/login");
    }
    setIsLoading(true);
    axios.post('https://todo-sv.vercel.app/todo/get-todos', {}, {
      headers: {
        "Authorization": `Bearer ${localStorage.getItem("token")}`
      }
    }).then(res => {
      ctx.setTodo.setTodo(res.data.allTodos);
      setIsLoading(false);
    }).catch(err => {
      console.error(err);
    })


  }, []);

  const lightModeChangeHandler = () => {
    axios.get("https://todo-sv.vercel.app/auth/website", {
      headers: {
        "Authorization": `Bearer ${localStorage.getItem("token")}`
      }
    }).then(res => {
      ctx.setMode.changeMode();
    }).catch(err => {
      console.error(err);
    })
  };

  return (
    <div className={`${!ctx.mode ? 'bg-dark_blue' : null} h-screen relative`}>
      <Head>
        <title>Todo App</title>
        <meta name="description" content="A todo application" />
        <link rel="icon" href="/favicon-32x32.png" />
      </Head>
      {ctx.auth ? (
        <>
          <Profile setCredentials={setShowCredentials} user={ctx.name} />
          <Header changeMode={lightModeChangeHandler} />
          {isLoading ? (<div className={`w-full flex items-center justify-center h-1/2 ${!ctx.mode ? 'text-light_gray' : ''}`}><svg className="animate-spin -ml-1 mr-3 h-10 w-10" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
            <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
          </svg></div>) : (<TodoList />)}
          {showCredentials ? (<Setting setCredentials={setShowCredentials} />) : null}
        </>) : null}

    </div>
  )
}
