import React from "react";
import { FoodBarProps } from "../../../types/statusbars";

const FoodBar: React.FC<FoodBarProps> = ({ value, icon }) => (
  <div className="relative flex-1 h-full rounded-br-md">
    <div className="absolute inset-0 bg-gray-900 rounded-bl-md"></div>
    <div
      className="absolute inset-y-0 left-0 bg-amber-500 h-full transition-all duration-500"
      style={{ width: `${value}%` }}
    ></div>
    <div className="relative flex items-center justify-center w-full h-full opacity-80">
      <i className={`${icon || "fas fa-drumstick-bite"} text-white text-base pr-1`}></i>
      <span className="text-white font-bold drop-shadow font-roboto">{value}</span>
    </div>
  </div>
);

export default FoodBar;
