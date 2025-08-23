import React, { useState } from "react";
import PlayerStatusHud from "././PlayerHud/PlayerStatusHud";
import Minimap from "./VehicleHud/Minimap";
import VehicleSpeedDisplay from "./VehicleHud/VehicleSpeedDisplay";
import DraggableComponent from "./HudEditor/DraggableComponent";
import EditModeOverlay from "./HudEditor/EditModeOverlay";
import { debugData } from "../utils/debugData";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { fetchNui } from "../utils/fetchNui";
import { IconConfigs } from "../types/iconconfigs";
import { Position, HudPositions, EditModeData } from "../types/hudeditor";

if (import.meta.env.MODE === "development") { // If we are in the browser let's show all the UI so we can actually see what we are doing
  debugData(
    [
      {
        action: "setVisible",
        data: true,
      },
      { 
        action: "setEditMode", 
        data: { editMode: true }
      }
    ],
    100
  );
}

const App: React.FC = () => {
  const isDev = import.meta.env.MODE === "development";
  const [vehicleSpeed, setVehicleSpeed] = useState(0);
  const [speedUnit, setSpeedUnit] = useState<'MPH' | 'KM/H'>('MPH');
  const [inVehicle, setInVehicle] = useState(true);
  const [editMode, setEditMode] = useState(false);
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

  const [hudPositions, setHudPositions] = useState<HudPositions>({
    playerHud: { x: 0, y: 0 },
    speedometer: { x: window.innerWidth - 180, y: window.innerHeight - 180 }
  });

  const [forceShowMinimap, setForceShowMinimap] = useState(false);
  const [forceShowVehicleHud, setForceShowVehicleHud] = useState(false);

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

  useNuiEvent<EditModeData>("setEditMode", (data) => {
    setEditMode(data.editMode);
    if (data.editMode) {
      setForceShowMinimap(true);
      setForceShowVehicleHud(true);
    } else {
      setForceShowMinimap(false);
      setForceShowVehicleHud(false);
    }
  });

  useNuiEvent<HudPositions>("loadPositions", (positions) => {
    setHudPositions(prev => {
      const newPositions = {
        ...prev,
        ...positions
      };
      
      return newPositions;
    });
  });

  useNuiEvent<boolean>("resetToDefaults", () => {
    const defaultPositions = {
      playerHud: { x: 0, y: 40 },
      speedometer: { x: window.innerWidth - 180, y: window.innerHeight - 180 }
    };
    
    setHudPositions(defaultPositions);
  });

  const handlePositionChange = (componentId: string, position: Position) => {
    const newPositions = {
      ...hudPositions,
      [componentId]: position
    };
    setHudPositions(newPositions);
    
    fetchNui('savePositions', newPositions);
  };

  const getDefaultPositions = () => {
    return {
      playerHud: { x: 100, y: 20 },
      speedometer: { x: window.innerWidth - 180, y: window.innerHeight - 180 }
    };
  };

  const currentPositions = isDev
    ? getDefaultPositions()
    : (editMode ? { ...getDefaultPositions(), ...hudPositions } : hudPositions);

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

      <EditModeOverlay isVisible={editMode} />

      <DraggableComponent
        componentId="playerHud"
        editMode={editMode}
        initialPosition={currentPositions.playerHud}
        onPositionChange={handlePositionChange}
        style={{
          transform: editMode ? 'scale(0.8)' : 'scale(0.8)',
          transformOrigin: "top left",
          width: "fit-content",
        }}
      >
        <div className="flex">
            <div className="z-10 w-full">
              <PlayerStatusHud />
            </div>
        </div>
      </DraggableComponent>

      <div 
        style={{
          position: 'absolute',
          left: `${window.innerWidth * 0.02}px`,
          top: `${window.innerHeight - 245 - (window.innerHeight * 0.07)}px`,
          pointerEvents: 'none',
          zIndex: 1000,
        }}
      >
        <Minimap forceShow={forceShowMinimap} />
      </div>

      <DraggableComponent
        componentId="speedometer"
        editMode={editMode}
        initialPosition={currentPositions.speedometer}
        onPositionChange={handlePositionChange}
      >
        <VehicleSpeedDisplay 
          speed={forceShowVehicleHud ? 85 : vehicleSpeed} 
          unit={speedUnit} 
          inVehicle={inVehicle || forceShowVehicleHud} 
        />
      </DraggableComponent>
    </>
  );
};

export default App;
