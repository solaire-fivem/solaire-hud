import React, { useState } from "react";
import PlayerStatusHud from "././PlayerHud/PlayerStatusHud";
import Minimap from "./VehicleHud/Minimap";
import VehicleSpeedDisplay from "./VehicleHud/VehicleSpeedDisplay";
import { debugData } from "../utils/debugData";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { IconConfigs } from "../types/iconconfigs";

if (import.meta.env.MODE === "development") { // If we are in the browser let's show all the UI so we can actually see what we are doing
  debugData(
    [
      {
        action: "setVisible",
        data: true,
      },
    ],
    100
  );
}

const App: React.FC = () => {
  const isDev = import.meta.env.MODE === "development";
  const [vehicleSpeed, setVehicleSpeed] = useState(0);
  const [speedUnit, setSpeedUnit] = useState<'MPH' | 'KM/H'>('MPH');
  const [inVehicle, setInVehicle] = useState(true);
  const [icons, setIcons] = useState<IconConfigs>({
    healthIcon: 'fas fa-heart',
    deadIcon: 'fas fa-face-dizzy',
    staminaIcon: 'fas fa-person-running',
    foodIcon: 'fas fa-drumstick-bite',
    waterIcon: 'fas fa-bottle-water',
    stressIcon: 'fas fa-brain',
    fuelIcon: 'fas fa-gas-pump',
    seatbeltIcon: 'fas fa-user-slash'
  });

  useNuiEvent<{
    vehicleFuel?: number,
    seatbelt?: boolean,
    vehicleSpeed?: number,
    inVehicle?: boolean,
    speedUnit?: 'MPH' | 'KM/H'
  }>("updateVehicleHud", (data) => {
    if (typeof data.vehicleSpeed === 'number') setVehicleSpeed(data.vehicleSpeed);
    if (typeof data.inVehicle === 'boolean') setInVehicle(data.inVehicle);
    if (data.speedUnit === 'MPH' || data.speedUnit === 'KM/H') setSpeedUnit(data.speedUnit);
  });

  useNuiEvent<IconConfigs>("setIcons", (iconConfigs) => {
    setIcons(prev => ({
      ...prev,
      ...iconConfigs
    }));
  });

  return (
    <>
      {isDev && (
        <div
          style={{
            backgroundImage: 'url("https://i.imgur.com/LzJc23K.jpeg")',
            backgroundSize: "cover",
            backgroundPosition: "center",
            minHeight: "100vh",
            minWidth: "100vw",
            position: "fixed",
          }}
        />
      )}
      <div
        style={{
          transform: `scale(0.8)`,
          transformOrigin: "top left",
          width: "fit-content",
        }}
      >
        <div className="flex">
          <div className="mt-3">
            <div className="absolute left-0 z-20"></div>
            <div className="z-10 w-full">
              <PlayerStatusHud />
            </div>
          </div>
        </div>
      </div>

      <div>
        <Minimap />
      </div>

      <div>
        <VehicleSpeedDisplay speed={vehicleSpeed} unit={speedUnit} inVehicle={inVehicle} />
      </div>
    </>
  );
};

export default App;
