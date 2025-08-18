import React from "react";
import { ArmorIconProps } from "../../types/playerhud";

const ArmorIcon: React.FC<ArmorIconProps> = ({
  armor,
  className = "absolute bottom-0 left-0 opacity-90",
}) => {
  const armorHeight = `${Math.max(0, Math.min(armor, 100))}%`;

  return (
    <div
      className={`w-8 h-8 bg-gray-900 border-2 border-gold rounded-full 
      flex items-center justify-center overflow-hidden shadow-lg z-10 ${className}`}
    >
      {armor > 0 && (
        <div
          className="absolute inset-x-0 bottom-0 bg-blue-900 z-0"
          style={{
            height: armorHeight,
            transition: "height 0.3s ease-in-out",
          }}
          aria-label={`Armor: ${armor}%`}
        ></div>
      )}
      <div className="relative z-20 text-white">
        <i className="fas fa-shield-alt"></i>
      </div>
    </div>
  );
};

export default ArmorIcon;
