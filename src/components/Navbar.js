import React, { useState } from "react";
import { useTrack } from '@splitsoftware/splitio-react';
import Button from './Button.js';
import harnessLogo from '../harness-logo-white.png';
import '../App.css'

const Navbar = ({ }) => {
  // Determines if the "menu icon" was clicked or not. Note that this icon is only visible when the window width is small.
  const [menuClicked, setMenuClicked] = useState(false);

  const toggleMenuClick = () => {
    setMenuClicked(!menuClicked);
  };
  const navbarLinks = ["one", "two"];
  const track = useTrack();
  return (
    <nav className="navbar">
      <img src={harnessLogo} className="navbar__logo" />
      <Button value="Join Us"/>
    </nav>
  );
};

export default Navbar;
