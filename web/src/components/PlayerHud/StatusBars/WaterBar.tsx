import React from "react";
import { WaterBarProps } from "../../../types/statusbars";

const WaterBar: React.FC<WaterBarProps> = ({ value, icon }) => (
  <div className="relative flex-1 h-full border-l-2 border-r-2 border-gold">
    <div className="absolute inset-0 bg-gray-900 opacity-50 "></div>
    <div
      className="absolute inset-y-0 left-0 bg-blue-400 h-full transition-all duration-500"
      style={{ width: `${value}%` }}
    ></div>
    <div className="relative flex items-center justify-center w-full h-full opacity-80">
      <i className={`${icon || "fas fa-bottle-water"} text-white text-base mr-0.5 pr-1`}></i>
      <span className="text-white font-bold drop-shadow font-roboto">{value}</span>
    </div>
  </div>
);

export default WaterBar;
