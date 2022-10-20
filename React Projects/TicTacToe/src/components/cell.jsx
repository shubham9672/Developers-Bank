import React, { Component } from "react";

class CellComponent extends Component {
  render() {
    const { cell, mark } = this.props;
    if (cell.value === " ")
      return (
        <button className="cell" onClick={() => mark(cell)}>
          {cell.value}
        </button>
      );
    return (
      <button className="cell">
        <span>{cell.value}</span>
      </button>
    );
  }
}

export default CellComponent;
