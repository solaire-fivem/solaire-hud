import React from "react";
import { VehicleSpeedDisplayProps } from "../../types/vehiclehud";

const VehicleSpeedDisplay: React.FC<VehicleSpeedDisplayProps> = ({ speed, unit = 'MPH', inVehicle = false }) => {
    if (!inVehicle) return null;
    return (
        <div className="z-50 flex items-center justify-center opacity-90">
            <svg width={140} height={140} viewBox="0 0 120 120">
                <circle
                    cx="60"
                    cy="60"
                    r={46}
                    stroke="#ab8e2cff"
                    strokeWidth={2}
                    fill="#111827"
                    style={{ filter: "drop-shadow(0 0 2px #ab8e2cff) drop-shadow(0 0 2px #ab8e2c88) drop-shadow(0 0 1px #111827)" }}
                />
                <text
                    x="60"
                    y="65"
                    textAnchor="middle"
                    className="font-cinzel"
                    fontSize="2.7em"
                    fill="white"
                    style={{ textShadow: "0 0 2px #ab8e2cff, 0 0 1px #111827" }}
                >
                    {speed}
                </text>
                <text
                    x="60"
                    y="88"
                    textAnchor="middle"
                    className="font-cinzel"
                    fontSize="0.8em"
                    fill="#FFD700"
                    style={{ textShadow: "0 0 1px #ab8e2cff" }}
                >
                    {unit}
                </text>
            </svg>
        </div>
    );
};

export default VehicleSpeedDisplay;
