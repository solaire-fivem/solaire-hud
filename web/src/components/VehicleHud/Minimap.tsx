import React, { useState } from "react";
import { useNuiEvent } from "../../hooks/useNuiEvent";
import SeatbeltIcon from "./SeatbeltIcon";
import FuelIcon from "./FuelIcon";

const Minimap: React.FC = () => {
  const [displayMinimap, setDisplayMinimap] = useState<boolean>(false);
  const [streetName, setStreetName] = useState<string>("");
  const [currentTime, setCurrentTime] = useState<string>("");
  const [isSeatbeltOn, setIsSeatbeltOn] = useState<boolean>(false);
  const [fuelLevel, setFuelLevel] = useState<number>(100);
  const [inVehicle, setInVehicle] = useState<boolean>(false);

  useNuiEvent<{displayMinimap: boolean, streetName: string, currentTime: string}>("displayMinimap", (data) => {
    if (data.displayMinimap !== undefined) setDisplayMinimap(data.displayMinimap);
    if (data.streetName !== undefined) setStreetName(data.streetName);
    if (data.currentTime !== undefined) setCurrentTime(data.currentTime);
  });
  
  useNuiEvent<{
    vehicleFuel?: number,
    seatbelt?: boolean,
    inVehicle: boolean,
  }>("updateVehicleHud", (data) => {
    if (data.vehicleFuel !== undefined) setFuelLevel(data.vehicleFuel);
    if (data.seatbelt !== undefined) setIsSeatbeltOn(data.seatbelt);
    if (data.inVehicle !== undefined) setInVehicle(data.inVehicle);
  });

  if (!displayMinimap) return null;

  return (
    <div
      style={{
        position: "fixed",
        left: "38px",
        bottom: "76px",
        width: "300px",
        height: "245px",
        pointerEvents: "none",
        zIndex: 1000,
      }}
    >
      {/* Outer ring */}
      <div
        style={{
          width: "100%",
          height: "100%",
          borderRadius: "50%",
          border: "6px solid #abababff", 
          boxSizing: "border-box",
          position: "relative",
          zIndex: 1,
        }}
      >

        {inVehicle && (
          <>
            <SeatbeltIcon isSeatbeltOn={isSeatbeltOn} />
            <FuelIcon fuelLevel={fuelLevel} />
          </>
        )}

        <div
          style={{
            position: "absolute",
            width: "100%",
            height: "100%",
            borderRadius: "50%",
            background:
              "linear-gradient(to bottom, rgba(0,0,0,0) 0%, rgba(0,0,0,0.1) 40%, rgba(0,0,0,0.4) 80%, rgba(0,0,0,0.6) 100%)",
            pointerEvents: "none",
            zIndex: 2,
            top: 0,
            left: 0,
          }}
        ></div>

        {/* Minimap circle with inner border */}
        <div
          style={{
            width: "100%",
            height: "100%",
            borderRadius: "50%",
            boxSizing: "border-box",
            boxShadow: "0 0 2px 2px #ab8e2cff, 0 0 16px 2px #ab8e2c88, 0 0 16px 4px #111827",
            position: "relative",
            zIndex: 1,
          }}
        ></div>
      </div>

      {/* Time display */}
      <div
        style={{
          position: "absolute",
          bottom: "-15px",
          left: "50%",
          transform: "translateX(-50%)",
          backgroundColor: "#111827",
          borderRadius: "4px",
          color: "white",
          fontSize: "14px",
          fontFamily: "Cinzel, serif",
          textAlign: "center",
          width: "84px",
          zIndex: 2,
          opacity: 0.8,
          boxShadow: "0 0 2px 2px #ab8e2cff, 0 0 4px 2px #ab8e2c88, 0 0 8px 4px #111827",
        }}
      >
        {currentTime}
      </div>

      {/* Street name */}
      {streetName && streetName.trim() !== "" && (
        <div
          style={{
            position: "absolute",
            top: "-25px",
            left: "50%",
            transform: "translateX(-50%)",
            backgroundColor: "#111827",
            borderRadius: "8px",
            color: "white",
            fontSize: "16px",
            fontFamily: "Cinzel, serif",
            textAlign: "center",
            width: "260px",
            zIndex: 0,
            opacity: 0.8,
            boxShadow: "0 0 2px 2px #ab8e2cff, 0 0 4px 2px #ab8e2c88, 0 0 8px 4px #111827",
          }}
        >
          {streetName}
        </div>
      )}
      
    </div>
  );
};

export default Minimap;
