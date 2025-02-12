import React from "react";
import Button from './Button.js';
import harnessLogo from '../harness-logo-white.png';
import '../App.css'

const Navbar = ({ }) => {
  return (
    <nav className="navbar">
      <img src={harnessLogo} className="navbar__logo" />
      <Button value="Join Us"/>
    </nav>
  );
};

export default Navbar;
