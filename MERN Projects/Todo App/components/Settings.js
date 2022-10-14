import { useRef, useState } from "react";
import { notifyError, notifySuccess } from '../util/toastify';
import { ToastContainer } from 'react-toastify';
import axios from "axios";
import { useNodeContext } from "../context/nodes/NodeContext";


const Settings = ({ setCredentials }) => {
    const ctx = useNodeContext();
    const mode = ctx.mode;
    const [isLoading, setIsLoading] = useState(false);
    const email = useRef('');
    const password = useRef('');
    const oldPassword = useRef('');
    const rePassword = useRef('');

    const submitHandler = e => {
        e.preventDefault();
        if (password.current.value === rePassword.current.value) {
            setIsLoading(true);
            email.current.disabled = true;
            password.current.disabled = true;
            oldPassword.current.disabled = true;
            rePassword.current.disabled = true;
            axios.put("https://todo-sv.vercel.app/auth/update-user", {
                oldPassword: oldPassword.current.value,
                newPassword: password.current.value,
                rePassword: rePassword.current.value,
                email: email.current.value
            }, {
                headers: {
                    "Authorization": `Bearer ${localStorage.getItem("token")}`
                }
            }).then(res => {
                setIsLoading(false);
                notifySuccess(res.data.message);
                email.current.value = "";
                password.current.value = "";
                oldPassword.current.value = "";
                rePassword.current.value = "";
                setCredentials(false);
                email.current.disabled = false;
                password.current.disabled = false;
                oldPassword.current.disabled = false;
                rePassword.current.disabled = false;
            }).catch(err => {
                setIsLoading(false);
                console.error(err);
                notifyError(err?.response?.data?.message);
                email.current.disabled = false;
                password.current.disabled = false;
                oldPassword.current.disabled = false;
                rePassword.current.disabled = false;
            })
        } else {
            notifyError("New passwords doesn't match!");
        }
    };

    return (
        <>
            < ToastContainer />
            <form className={`absolute top-1/2 right-1/2 translate-x-1/2 -translate-y-1/2 w-11/12 h-2/5 md:w-1/2 lg:w-2/5 ${mode ? "bg-[#fff]" : "bg-dark_blue_light"}  rounded-xl flex justify-around flex-col p-4 shadow-2xl text-sm md:text-base`} onSubmit={submitHandler}>
                <div className={`h-1/6 border-b ${mode ? "border-b-light_gray1" : "border-b-dark_gray3"} text-base md:text-lg flex items-center justify-between`}>
                    <span className={`font-bold ${mode ? "" : "text-light_gray2"}`}>Settings</span>
                    <button onClick={e => {
                        setCredentials(false);
                        e.preventDefault();
                    }}>
                        <svg className="scale-75 cursor-pointer z-50" xmlns="http://www.w3.org/2000/svg" width="20" height="20">
                            <path
                                fill="#494C6B"
                                fillRule="evenodd"
                                d="M16.97 0l.708.707L9.546 8.84l8.132 8.132-.707.707-8.132-8.132-8.132 8.132L0 16.97l8.132-8.132L0 .707.707 0 8.84 8.132 16.971 0z"
                            ></path>
                        </svg>
                    </button>
                </div>
                <div className={`h-1/6 flex flex-row items-center justify-between border-b ${isLoading ? "cursor-not-allowed" : ""} ${mode ? "border-b-light_gray1" : "border-b-dark_gray3"}`}><span className={`w-1/5 mr-2 ${mode ? "" : "text-light_gray2"}`}>Email:</span> <input type="email" className={`rounded-lg py-1 pl-3 outline-none ${mode ? "bg-dark_gray1_hover" : "bg-light_gray1_hover"} w-4/5`} ref={email} required /></div>
                <div className={`h-1/6 flex flex-row items-center justify-between border-b ${isLoading ? "cursor-not-allowed" : ""} ${mode ? "border-b-light_gray1" : "border-b-dark_gray3"}`}><span className={`w-1/5 mr-2 ${mode ? "" : "text-light_gray2"}`}>Old Password:</span> <input type="password" className={`rounded-lg py-1 pl-3 outline-none ${mode ? "bg-dark_gray1_hover" : "bg-light_gray1_hover"} w-4/5`} ref={oldPassword} required /></div>
                <div className={`h-1/6 flex flex-row items-center justify-between border-b ${isLoading ? "cursor-not-allowed" : ""} ${mode ? "border-b-light_gray1" : "border-b-dark_gray3"}`}><span className={`w-1/5 mr-2 ${mode ? "" : "text-light_gray2"}`}>Password:</span> <input type="password" className={`rounded-lg py-1 pl-3 outline-none ${mode ? "bg-dark_gray1_hover" : "bg-light_gray1_hover"} w-4/5`} ref={password} required /></div>
                <div className={`h-1/6 flex flex-row items-center justify-between border-b ${isLoading ? "cursor-not-allowed" : ""} ${mode ? "border-b-light_gray1" : "border-b-dark_gray3"}`}><span className={`w-1/5 mr-2 ${mode ? "" : "text-light_gray2"}`}>Re-Password:</span> <input type="password" className={`rounded-lg py-1 pl-3 outline-none ${mode ? "bg-dark_gray1_hover" : "bg-light_gray1_hover"} w-4/5`} ref={rePassword} required /></div>
                <div className="h-1/5 flex items-center justify-center">
                    {isLoading ? <svg className="animate-spin -ml-1 mr-3 h-4 w-4 text-bright_blue" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                        <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                        <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                    </svg> : <button type="submit" className="bg-bright_blue py-2 px-4 rounded-full text-[#fff]">Submit</button>}
                </div>
            </form>
        </>
    )
}

export default Settings
