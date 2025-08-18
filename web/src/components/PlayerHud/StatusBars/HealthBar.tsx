import React from "react";
import { HealthBarProps } from "../../../types/statusbars";

const HealthBar: React.FC<HealthBarProps> = ({ value, isLow, isDead, icon, deadIcon }) => (
  <div className="relative flex-1 h-6 min-h-[24px] max-h-[24px] border-t-2 border-gold">
    <div className="absolute inset-0 bg-gray-900 opacity-50"></div>
    <div
      className={`absolute inset-y-0 left-0 ${
        isDead ? "bg-red-600" : isLow ? "bg-red-600" : "bg-green-600"
      } h-full transition-all duration-500`}
      style={{ width: isDead ? "100%" : `${value}%`, opacity: isDead ? 0.7 : 1 }}
    ></div>
    <div className="relative flex items-center left-6 w-full h-full opacity-80 min-h-[24px] max-h-[24px]">
      <i
        className={`${
          isDead ? (deadIcon || "fas fa-face-dizzy") : (icon || "fas fa-heart")
        } text-white pr-1 text-[16px] flex items-center justify-center mb-0.5 leading-4"`}
      ></i>
      {!isDead && <span className="text-white font-bold drop-shadow font-roboto">{value}</span>}
    </div>
  </div>
);

export default HealthBar;
