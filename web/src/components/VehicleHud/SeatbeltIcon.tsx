import React from "react";
import { SeatbeltIconProps } from "../../types/vehiclehud";

const SeatbeltIcon: React.FC<SeatbeltIconProps> = ({ isSeatbeltOn, icon }) => {
  const iconColor = isSeatbeltOn ? "text-green-500" : "text-red-500";

  return (
    <div
      className={"w-10 h-10 bg-[#111827] rounded-full flex items-center justify-center overflow-hidden shadow-lg z-20 absolute mt-[210px] ml-[220px] opacity-80"}
      style={{
        boxShadow: "0 0 2px 2px #ab8e2cff, 0 0 2px 1px #ab8e2c88, 0 0 8px 1px #111827",
      }}
    >
      <div className={`relative flex items-center justify-center leading-none ${iconColor}`}>
        <i className={`${icon || "fas fa-user-slash"} align-middle`}></i>
      </div>
    </div>
  );
};

export default SeatbeltIcon;
