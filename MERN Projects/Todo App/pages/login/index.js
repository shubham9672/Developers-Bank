import Head from 'next/head'
import React, { useState, useRef } from 'react'
import { useNodeContext } from '../../context/nodes/NodeContext'
import { ToastContainer } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import axios from 'axios';
import Router from 'next/router';
import { notifyError, notifySuccess } from '../../util/toastify';

const Login = () => {
    const ctx = useNodeContext();
    const [isLogin, setIsLogin] = useState(1);

    const name = useRef('');
    const email = useRef('');
    const password = useRef('');
    const rePassword = useRef('');

    const [isLoading, setIsLoading] = useState(false);

    const submitHandler = e => {
        e.preventDefault();
        if (isLogin) {
            if (email.current.value && password.current.value) {
                setIsLoading(true);
                axios.post('https://todo-sv.vercel.app/auth/login', {
                    email: email.current.value,
                    password: password.current.value
                }).then(res => {
                    setIsLoading(false);
                    notifySuccess(res.message);
                    ctx.login.loginHandler(res.data.token, res.data.name, res.data.userId);
                    ctx.setLoginstatus.setIsLogin(true);
                    // localStorage.setItem("light-mode", res.data.lightMode)
                    ctx.changeMode.setIsLightMode(res.data.lightMode);
                    Router.push("/")
                    console.log(res);
                }).catch(err => {
                    if (err) notifyError(err?.response?.data?.message);
                    console.error(err);
                    setIsLoading(false);
                })
            } else notifyError("Login is incomplete")
        } else {
            if (email.current.value && password.current.value && rePassword.current.value && name.current.value) {
                if (password.current.value !== rePassword.current.value) return notifyError("Your password doesn't match");
                setIsLoading(true);
                axios.post('https://todo-sv.vercel.app/auth/signup', {
                    email: email.current.value,
                    name: name.current.value,
                    password: password.current.value
                }).then(res => {
                    setIsLoading(false);
                    notifySuccess(res.data.message);
                    setIsLogin(true);
                    email.current.value = "";
                    name.current.value = "";
                    password.current.value = "";
                    rePassword.current.value = "";
                }).catch(err => {
                    notifyError(err.response.data.message);
                    console.error(err);
                    setIsLoading(false);
                })
            } else notifyError("Sign up is incomplete")
        }
    };

    return (
        <>
            <Head>
                <title>Todo App</title>
                <meta name="description" content="A todo application" />
                <link rel="icon" href="/favicon-32x32.png" />
            </Head>
            <div className='h-screen flex items-center bg-light_blue relative'>
                <ToastContainer />
                <div className={`flex items-center justify-center ${isLogin ? "h-1/3 md:h-2/5 lg:h-1/3" : "h-2/5 md:h-1/2 lg:h-2/5"} w-full`}>
                    <form className='w-4/5 md:w-1/2 lg:w-1/5 h-full rounded-lg bg-light_gray1 shadow-2xl p-8 flex flex-col justify-between' onSubmit={submitHandler}>
                        {isLogin ? (<>
                            <div className='flex items-center justify-start'>
                                <img src='./favicon-32x32.png' className='' />
                                <h1 className='pl-4 text-2xl'>LOGIN</h1>
                            </div>
                            <div className='flex flex-col'>
                                <h2>Email</h2>
                                <input className='w-full rounded-lg p-2 outline-none shadow-xl border border-[#fff]' type='email' ref={email} required />
                            </div>
                            <div className='flex flex-col'>
                                <h2>Password</h2>
                                <input className='w-full rounded-lg p-2 outline-none shadow-xl border border-[#fff]' type='password' ref={password} required />
                            </div>
                            <div className='flex flex-col items-center'>
                                {isLoading ? (<svg className="animate-spin -ml-1 mr-3 h-10 w-10 text-light_pink_active" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                                    <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                                    <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                                </svg>) : (<button type='submit' className='bg-light_pink w-full text-light_gray py-2 rounded-lg hover:bg-light_pink_hover active:bg-light_pink_active shadow-xl'>Login</button>)}
                            </div>
                            <div className={`flex flex-col justify-center ${isLoading && ("invisible")}`}>
                                <div>Need an account? <span className='cursor-pointer hover:text-bright_blue' onClick={() => setIsLogin(!isLogin)}>Sign up</span></div>
                            </div>
                        </>) : (<>
                            <div className='flex items-center justify-start'>
                                <img src='./favicon-32x32.png' className='' />
                                <h1 className='pl-4 text-2xl'>SIGN UP</h1>
                            </div>
                            <div className='flex flex-col'>
                                <h2>Name</h2>
                                <input className='w-full rounded-lg p-2 outline-none shadow-xl border border-[#fff]' type='name' ref={name} required />
                            </div>
                            <div className='flex flex-col'>
                                <h2>Email</h2>
                                <input className='w-full rounded-lg p-2 outline-none shadow-xl border border-[#fff]' type='email' ref={email} required />
                            </div>
                            <div className='flex flex-col'>
                                <h2>Password</h2>
                                <input className='w-full rounded-lg p-2 outline-none shadow-xl border border-[#fff]' type='password' ref={password} required />
                            </div>
                            <div className='flex flex-col'>
                                <h2>Re-Type Password</h2>
                                <input className='w-full rounded-lg p-2 outline-none shadow-xl border border-[#fff]' type='password' ref={rePassword} required />
                            </div>
                            <div className='flex flex-col justify-center items-center'>
                                {isLoading ? (<svg className="animate-spin -ml-1 mr-3 h-10 w-10 text-light_pink_active" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                                    <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                                    <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                                </svg>) : (<button type='submit' className='bg-light_pink w-full text-light_gray py-2 rounded-lg hover:bg-light_pink_hover active:bg-light_pink_active shadow-xl'>Sign Up</button>)}
                            </div>
                            <div className={`flex flex-col justify-center ${isLoading && ("invisible")}`}>
                                <div>Already have an account? <span className='cursor-pointer hover:text-bright_blue' onClick={() => setIsLogin(!isLogin)}>Login</span></div>
                            </div>
                        </>)}
                    </form>
                </div>
            </div>
        </>
    )
}

export default Login
