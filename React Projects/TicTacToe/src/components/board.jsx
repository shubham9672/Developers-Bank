import React, { Component } from "react";
import CellComponent from "./cell";
import "./css/board.css";

class Board extends Component {
  render() {
    const { cells, mark } = this.props;
    return (
      <div className="board m-2 text-center">
        {cells.map((row, index) => {
          return (
            <React.Fragment key={index}>
              {row.map((cell) => {
                return <CellComponent cell={cell} mark={mark} key={cell.id} />;
              })}
            </React.Fragment>
          );
        })}
      </div>
    );
  }
}

export default Board;
