import React from "react";
import { StressBarProps } from "../../../types/statusbars";

const StressBar: React.FC<StressBarProps> = ({ value, icon }) => (
  <div className="relative flex-1 h-full rounded-bl-md">
    <div className="absolute inset-0 bg-gray-900 opacity-50 rounded-bl-md"></div>
    <div
      className="absolute inset-y-0 left-0 bg-red-500 h-full transition-all duration-500 opacity-80"
      style={{ width: `${Math.round(value)}%` }}
    ></div>
    <div className="relative flex items-center justify-center w-full h-full opacity-80">
      <i className={`${icon || "fas fa-brain"} text-white text-base pr-1`}></i>
      <span className="text-white font-bold drop-shadow font-roboto">{Math.round(value)}</span>
    </div>
  </div>
);

export default StressBar;
