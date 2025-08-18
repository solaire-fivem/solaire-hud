import React from "react";
import { StaminaBarProps } from "../../../types/statusbars";

const StaminaBar: React.FC<StaminaBarProps> = ({ value, icon }) => (
  <div className="relative flex-1 h-6 min-h-[24px] max-h-[24px] border-t-2 border-gold">
    <div className="absolute inset-0 bg-gray-900 opacity-50"></div>
    <div
      className="absolute inset-y-0 left-0 bg-yellow-500 h-full transition-all duration-500"
      style={{ width: `${value}%` }}
    ></div>
    <div className="relative flex items-center left-6 w-full h-full opacity-80">
      <i className={`${icon || "fas fa-person-running"} text-white text-base pr-1`}></i>
      <span className="text-white font-bold drop-shadow font-roboto ml-0.5">{value}</span>
    </div>
  </div>
);

export default StaminaBar;
