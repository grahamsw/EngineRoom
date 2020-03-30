import React, { Component } from 'react';
import './MyCanvas.css';
import Logger from './logger.js';

class MyCanvas extends Component {
  constructor(props){
    super(props);
    this.state = {
                  height: props.height,
                  width: props.width,
                  contrastThreshold: props.contrastThreshold,
                  contrastColor: props.contrastColor
                };
    this.log = Logger.log(this, true);

  }

luminanace(r, g, b) {
    var a = [r, g, b].map(function (v) {
        v /= 255;
        return v <= 0.03928
            ? v / 12.92
            : Math.pow((v + 0.055) / 1.055, 2.4);
    });
    return a[0] * 0.2126 + a[1] * 0.7152 + a[2] * 0.0722;
}

contrast(rgb1, rgb2) {
    return (this.luminanace(rgb1[0], rgb1[1], rgb1[2]) + 0.05)
        / (this.luminanace(rgb2[0], rgb2[1], rgb2[2]) + 0.05);
}

  componentDidMount() {
          this.updateCanvas();
      }

  updateCanvas(){
    this.log(this.refs, "");
    const context = this.refs.canvas.getContext('2d');
//    var canvas = document.querySelector("#myCanvas");
//    var context = canvas.getContext("2d");
  //var black = "rgb(0,0,0)";
    var b = 125;
    for (var r = 0; r < 255; r++) {
      for (var g = 0; g < 255; g++) {

        //  var cnt = contrast([r,g,b], [0,0,0]);
        //  console.log(cnt);
        context.fillStyle =  "rgb(" + r + "," + g + "," + b + ")";
        context.fillRect(2*r, 2*g, 2, 2);
      }
    }
  }

  render() {
  //  this.log(this.state.height, 'header');
    return (
      <canvas ref="canvas" className="MyCanvas" height={this.state.height} width={this.state.width}/>
    );
  }
}

export default MyCanvas;
