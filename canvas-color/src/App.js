import React, { Component } from 'react';
import './App.css';
import MyCanvas from './MyCanvas.js';
// We can just import Slider or Range to reduce bundle size
import Slider from 'rc-slider/lib/Slider';
// import Range from 'rc-slider/lib/Range';
import 'rc-slider/assets/index.css';

import Logger from './logger.js';

class App extends Component {

  constructor(props){
    super(props);
    this.log =  Logger.log(this, true);
  }

  update(){
    console.log('poo');
console.log(this.refs);
    console.log(this.refs.thirdColorVal.value);


  }

  render() {
    return (
      <div className="App">
        <MyCanvas height="500" width="500"/>
        <Slider ref="thirdColorVal"  min={0} max={255}  default={125} onChange={this.update} />
      </div>
    );
  }
}

export default App;
