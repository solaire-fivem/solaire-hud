import React from "react";
import { FuelIconProps } from "../../types/vehiclehud";

const FuelIcon: React.FC<FuelIconProps> = ({ fuelLevel, icon }) => {
  const iconColor = fuelLevel > 25 ? "text-white" : "text-red-500";
  const fuelHeight = `${Math.max(0, Math.min(fuelLevel, 100))}%`;

  return (
    <div
      className={"w-10 h-10 bg-[#111827] rounded-full flex items-center justify-center overflow-hidden shadow-lg z-20 absolute mt-[175px] ml-[262px] opacity-95"}
      style={{
        boxShadow: "0 0 2px 2px #ab8e2cff, 0 0 2px 1px #ab8e2c88, 0 0 8px 1px #111827",
      }}
    >
      {fuelLevel > 0 && (
        <div
          className="absolute inset-x-0 bottom-0 bg-amber-600 z-0"
          style={{
            height: fuelHeight,
            transition: "height 0.3s ease-in-out",
          }}
          aria-label={`Fuel: ${fuelLevel}%`}
        ></div>
      )}
      <div className={`relative flex items-center justify-center leading-none ${iconColor}`}>
        <i className={`${icon || "fas fa-gas-pump"} align-middle`}></i>
      </div>
    </div>
  );
};

export default FuelIcon;
