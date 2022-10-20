import "./App.css";
import React, { Component } from "react";
import Board from "./components/board";

class App extends Component {
  state = {
    cells: [
      [
        { id: 1, value: " " },
        { id: 2, value: " " },
        { id: 3, value: " " },
      ],
      [
        { id: 4, value: " " },
        { id: 5, value: " " },
        { id: 6, value: " " },
      ],
      [
        { id: 7, value: " " },
        { id: 8, value: " " },
        { id: 9, value: " " },
      ],
    ],
    player: 1,
    playerWon: undefined,
    remainingCells: 9,
  };

  render() {
    return (
      <div className="container-fluid min-vh-100 App-header">
        <h2>Tic Tac Toe</h2>
        {this.getBoard()}
        {this.gameEndMsg()}
        <button className="btn btn-primary" onClick={this.reset}>
          New Game
        </button>
      </div>
    );
  }

  //Helper methods
  getBoard = () => {
    return (
      <React.Fragment>
        <h4>
          Current turn: Player {this.state.player} (
          {this.state.player === 1 ? "X" : "O"})
        </h4>
        <Board
          cells={this.state.cells}
          mark={!this.state.playerWon ? this.mark : () => {}}
        />
      </React.Fragment>
    );
  };

  gameEndMsg() {
    if (this.state.playerWon)
      return (
        <h4>
          Player Won: {this.state.playerWon}(
          {this.state.playerWon === 1 ? "X" : "O"})
        </h4>
      );

    if (this.state.remainingCells === 0) return <p>Looks like no one won!</p>;
  }

  mark = (square) => {
    if (square.value === " ") {
      let cells = [...this.state.cells];
      const rowNo = Math.floor((square.id - 1) / 3);
      const index = cells[rowNo].indexOf(square);
      cells[rowNo][index] = { ...cells[rowNo][index] };
      cells[rowNo][index].value = this.state.player === 1 ? "X" : "O";
      this.setState({
        cells: cells,
        player: this.state.player === 1 ? 2 : 1,
        remainingCells: this.state.remainingCells - 1,
      });
    } else {
      return;
    }
    console.log("marked ", square.id, " by player ", this.state.player);
  };

  reset = () => {
    let cells = [
      [
        { id: 1, value: " " },
        { id: 2, value: " " },
        { id: 3, value: " " },
      ],
      [
        { id: 4, value: " " },
        { id: 5, value: " " },
        { id: 6, value: " " },
      ],
      [
        { id: 7, value: " " },
        { id: 8, value: " " },
        { id: 9, value: " " },
      ],
    ];
    this.setState({
      cells: cells,
      player: 1,
      playerWon: undefined,
      remainingCells: 9,
    });
  };

  componentDidUpdate() {
    const { player, cells, playerWon } = this.state;
    if (playerWon) return;
    let check;
    if (player === 1) {
      // lats turn was player 2
      check = "O";
    } else {
      // last turn was player 1
      check = "X";
    }

    let win;

    for (let i = 0; i < 3; i++) {
      win = true;
      for (let j = 0; j < 3; j++) {
        if (cells[i][j].value !== check) {
          win = false;
          break;
        }
      }
      if (win === true) {
        this.setState({ playerWon: player === 1 ? 2 : 1 });
        return;
      }
    }

    for (let i = 0; i < 3; i++) {
      win = true;
      for (let j = 0; j < 3; j++) {
        if (cells[j][i].value !== check) {
          win = false;
          break;
        }
      }
      if (win === true) {
        this.setState({ playerWon: player === 1 ? 2 : 1 });
        return;
      }
    }

    win = true;
    for (let i = 0; i < 3; i++) {
      if (cells[i][i].value !== check) {
        win = false;
        break;
      }
    }
    if (win === true) {
      this.setState({ playerWon: player === 1 ? 2 : 1 });
      return;
    }

    win = true;
    for (let i = 0, j = 2; i < 3; i++, j--) {
      if (cells[i][j].value !== check) {
        win = false;
        break;
      }
    }
    if (win === true) {
      this.setState({ playerWon: player === 1 ? 2 : 1 });
      return;
    }
  }
}

export default App;
