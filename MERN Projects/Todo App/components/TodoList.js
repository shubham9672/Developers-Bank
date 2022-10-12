import { useState } from "react"
import Todo from "./Todo.js"
import { useNodeContext } from "../context/nodes/NodeContext.js";
import axios from "axios";
import { ToastContainer } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import { notifyError, notifySuccess } from "../util/toastify.js";

const TodoList = () => {
    const ctx = useNodeContext();
    const mode = ctx.mode;
    const [check, setCheck] = useState(false);
    const [display, setDisplay] = useState(0);
    const [isLoading, setIsLoading] = useState(false);

    const keyPressHandler = (e) => {
        if (e.key === "Enter" && e.target.value !== "") {
            e.target.disabled = true;
            setIsLoading(true);
            axios.post("https://todo-sv.vercel.app/todo/add-todo", {
                todo: e.target.value,
                index: (ctx.todo.length),
                isCompleted: check,
                userId: ctx.userId,
            }, {
                headers: {
                    "Authorization": `Bearer ${localStorage.getItem("token")}`
                }
            }).then(res => {
                if (res.status === 200) {
                    setIsLoading(false);
                    e.target.disabled = false;
                    ctx.setTodo.setTodo([...ctx.todo, res.data.result]);
                    e.target.value = "";
                    setCheck(false);
                    notifySuccess("Todo Added Successfully");
                }
            }).catch(err => {
                setIsLoading(false);
                e.target.disabled = false;
                console.error(err);
                notifyError(err?.response?.data?.message);
            });
        }
    };

    const removeTodoHandler = (todoId) => {
        const array = [...ctx.todo];
        const index = array.map(val => val._id).indexOf(todoId);
        if (index !== -1) {
            array.splice(index, 1);
            axios.put("https://todo-sv.vercel.app/todo/change-index", {
                todo: array
            }, {
                headers: {
                    "Authorization": `Bearer ${localStorage.getItem("token")}`
                }
            }).then(res => {
                console.log(res);
                ctx.setTodo.setTodo(array);
                notifySuccess("Successfully deleted the todo");
            }).catch(err => {
                console.error(err);
                notifyError(err?.response?.data?.message);
            })
        }
    };

    const setDoneHandler = (todoId) => {
        const array = [...ctx.todo];
        const index = array.map(val => val._id).indexOf(todoId);
        if (index !== -1) {
            axios.put("https://todo-sv.vercel.app/todo/update-todo", {
                id: todoId,
                isCompleted: !array[index].isCompleted
            }, {
                headers: {
                    "Authorization": `Bearer ${localStorage.getItem("token")}`
                }
            }).then(res => {
                array[index].isCompleted = !array[index].isCompleted;
                ctx.setTodo.setTodo(array);
                notifySuccess("Todo updated");
            }).catch(err => {
                console.error(err);
                notifyError(err?.response?.data?.message);
            })
        }
    };

    const clearStatusHandler = () => {
        axios.delete("https://todo-sv.vercel.app/todo/clear-completed", {
            headers: {
                "Authorization": `Bearer ${localStorage.getItem("token")}`
            }
        }).then(res => {
            const array = ctx.todo.filter(val => val.isCompleted === false);
            ctx.setTodo.setTodo(array);
            notifySuccess("Todos updated successfully!");
        }).catch(err => {
            console.error(err);
            notifyError(err?.response?.data?.message);
        })
    };

    const dragHandler =  (data, switchIndex) => {
        console.log(data, switchIndex);
        const tempTodoTask = ctx.todo.filter((todo, i) => i !== Number(data.index));
        tempTodoTask.splice(switchIndex, 0, data.type);
        ctx.setTodo.setTodo(tempTodoTask);
        console.log(tempTodoTask);
        axios.put("https://todo-sv.vercel.app/todo/change-index", {
            todo: tempTodoTask
        }, {
            headers: {
                "Authorization": `Bearer ${localStorage.getItem("token")}`
            }
        }).then(res =>{

        }).catch(err => {
            console.error(err);
            notifyError(err?.response?.data?.message);
        })
    };

    return (
        <>
            <ToastContainer />
            <div className="flex justify-center -translate-y-24 items-center flex-col">
                <div className="w-full lg:w-[71%] flex justify-center items-center">
                    <div className="w-[90%] md:w-[55%] flex justify-center items-center mb-5 -translate-x-3 relative">
                        <span className={`${!isLoading ? "hidden" : "flex"} absolute h-5 w-5 top-0 right-0 -mt-2 -mr-2 z-50`}>
                            <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-bright_blue opacity-75"></span>
                            <span className="relative inline-flex rounded-full h-5 w-5 bg-bright_blue"></span>
                        </span>
                        <div className={`w-5 h-5 rounded-full cursor-pointer translate-x-8 z-50 flex items-center justify-center ${check ? `bg-gradient-to-br from-light_blue to-light_pink border ${mode ? 'border-[#fff]' : 'border-dark_blue2'}` : `border border-light_gray2`}`} onClick={() => setCheck(!check)}>
                            <svg className={`${check ? 'block' : 'hidden'}`} xmlns="http://www.w3.org/2000/svg" width={11} height={9}>
                                <path fill="none" stroke="#FFF" strokeWidth={2} d="M1 4.304L3.696 7l6-6" />
                            </svg>
                        </div>
                        <input type="text" className={`${!mode ? 'bg-dark_blue2 text-dark_gray1' : "bg-[#fff]"} ${isLoading ? "cursor-not-allowed" : ""} rounded-md w-full pl-10 py-5 placeholder:josefin placeholder:text-xs md:placeholder:text-base lg:placeholder:text-lg text-xs md:text-base lg:text-xl focus:outline-none`} placeholder="Create a new todo ..." onKeyPress={keyPressHandler} />
                    </div>
                </div>
                <div className="flex flex-col items-center w-[95%] lg:w-[70%]">
                    {ctx.todo.map((val, i) => {
                        if (display === 0) return (<Todo mode={mode} key={val._id} todoId={val._id} todoRemoval={removeTodoHandler} changeStatus={setDoneHandler} todo={val.todo} completedStatus={val.isCompleted} index={i} changeIndexOnDrag={dragHandler} todoObject={val} />);
                        if (display === 1 && val.isCompleted === false) return (<Todo mode={mode} key={val._id} todoId={val._id} todoRemoval={removeTodoHandler} changeStatus={setDoneHandler} todo={val.todo} index={i} changeIndexOnDrag={dragHandler} todoObject={val} />)
                        if (display === 2 && val.isCompleted === true) return (<Todo mode={mode} key={val._id} todoId={val._id} todoRemoval={removeTodoHandler} changeStatus={setDoneHandler} todo={val.todo} index={i} changeIndexOnDrag={dragHandler} todoObject={val} />)
                    })}
                    <div className={`flex items-center justify-between w-[90%] md:w-[55%] ${!mode ? 'bg-dark_blue2' : 'bg-[#fff]'} text-xs md:text-base rounded-b-md first:rounded-t-md h-16 border-b ${mode ? 'border-light_gray1' : 'border-dark_blue2'} last:border-none shadow-xl px-3`}>
                        <div className="josefin text-light_gray2">{ctx.todo.filter(val => val.isCompleted === false).length} items left</div>
                        <div className={`hidden justify-evenly items-center w-[90%] md:w-[55%] lg:flex ${!mode ? 'bg-dark_blue2' : 'bg-[#fff]'}`}>
                            <p className={`font-bold cursor-pointer ${display === 0 ? 'text-bright_blue' : `text-light_gray2 ${mode ? 'hover:text-light_gray2_hover' : 'hover:text-dark_gray1_hover'}`}`} onClick={() => setDisplay(0)}>All</p>
                            <p className={`font-bold cursor-pointer ${display === 1 ? 'text-bright_blue' : `text-light_gray2 ${mode ? 'hover:text-light_gray2_hover' : 'hover:text-dark_gray1_hover'}`}`} onClick={() => setDisplay(1)}>Active</p>
                            <p className={`font-bold cursor-pointer ${display === 2 ? 'text-bright_blue' : `text-light_gray2 ${mode ? 'hover:text-light_gray2_hover' : 'hover:text-dark_gray1_hover'}`}`} onClick={() => setDisplay(2)}>Completed</p>
                        </div>
                        <div className="josefin text-light_gray2 hover:text-light_gray2_hover cursor-pointer" onClick={() => clearStatusHandler()}>Clear Completed</div>
                    </div>
                </div>
                <div className={`flex lg:hidden items-center justify-center mt-10 w-[95%] lg:w-[70%] text-sm`}>
                    <div className={`flex justify-evenly items-center w-[90%] md:w-[55%] ${!mode ? 'bg-dark_blue2' : 'bg-[#fff]'} rounded-md h-14 border-b border-light_gray1 last:border-none shadow`}>
                        <p className={`font-bold cursor-pointer ${display === 0 ? 'text-bright_blue' : `text-light_gray2 ${mode ? 'hover:text-light_gray2_hover' : 'hover:text-dark_gray1_hover'}`}`} onClick={() => setDisplay(0)}>All</p>
                        <p className={`font-bold cursor-pointer ${display === 1 ? 'text-bright_blue' : `text-light_gray2 ${mode ? 'hover:text-light_gray2_hover' : 'hover:text-dark_gray1_hover'}`}`} onClick={() => setDisplay(1)}>Active</p>
                        <p className={`font-bold cursor-pointer ${display === 2 ? 'text-bright_blue' : `text-light_gray2 ${mode ? 'hover:text-light_gray2_hover' : 'hover:text-dark_gray1_hover'}`}`} onClick={() => setDisplay(2)}>Completed</p>
                    </div>
                </div>
                <div className="text-light_gray2 mt-10">
                    Drag and drop to reorder list
                </div>
            </div>
        </>
    )
}

export default TodoList
