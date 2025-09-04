import React, { useState } from "react";
import "../App.css";
import { useNuiEvent } from "../../hooks/useNuiEvent";
import PlayerName from "./PlayerName";
import PlayerIconContainer from "./PlayerIconContainer";
import HealthBar from "./StatusBars/HealthBar";
import StaminaBar from "./StatusBars/StaminaBar";
import FoodBar from "./StatusBars/FoodBar";
import WaterBar from "./StatusBars/WaterBar";
import StressBar from "./StatusBars/StressBar";
import { PlayerStats } from "../../types/playerhud";
import { IconConfigs } from "../../types/iconconfigs";

const PlayerStatusHud: React.FC = () => {
  const [health, setHealth] = useState<number>(100);
  const [stamina, setStamina] = useState<number>(100);
  const [hunger, setHunger] = useState<number>(100);
  const [thirst, setThirst] = useState<number>(100);
  const [stress, setStress] = useState<number>(0);
  const [isDead, setIsDead] = useState<boolean>(false);
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

  const isLowHealth = health > 0 && health < 35;

  useNuiEvent<Partial<PlayerStats>>("updatePlayerStats", (data) => {
    setHealth((previousValue) =>
      typeof data.health === "number" ? Math.max(0, data.health) : previousValue
    );
    setStamina((previousValue) =>
      typeof data.stamina === "number" ? data.stamina : previousValue
    );
    setStress((prev) => (typeof data.stress === "number" ? data.stress : prev));
  });

  useNuiEvent<{ hunger?: number; thirst?: number }>("updateNeeds", (data) => {
    if (typeof data.hunger === "number") setHunger(data.hunger);
    if (typeof data.thirst === "number") setThirst(data.thirst);
  });

  useNuiEvent<boolean>("setPlayerDead", (dead) => {
    setIsDead(!!dead);
  });

  useNuiEvent<IconConfigs>("setIcons", (iconConfigs) => {
    setIcons(prev => ({
      ...prev,
      ...iconConfigs
    }));
  });

  return (
    <div className="flex items-center select-none">
      <style>{`
        .hud-glow {
          box-shadow: 0 0 2px 2px #ab8e2cff, 0 0 16px 2px #ab8e2c88, 0 0 8px 1px #111827;
        }
      `}</style>

      <div className="z-10">
        <PlayerIconContainer />
      </div>

      {/* Status bars container */}
      <div className="bg-gray-900 bg-opacity-80 rounded-lg flex flex-col overflow-hidden w-64 -ml-3 hud-glow">
        <PlayerName />

        <HealthBar 
          value={health} 
          isLow={isLowHealth} 
          isDead={isDead} 
          icon={icons.healthIcon}
          deadIcon={icons.deadIcon}
        />
        <StaminaBar value={stamina} icon={icons.staminaIcon} />

        <div className="flex h-6 border-t-2 border-gold">
          <FoodBar value={hunger} icon={icons.foodIcon} />
          <WaterBar value={thirst} icon={icons.waterIcon} />
          <StressBar value={stress} icon={icons.stressIcon} />
        </div>
      </div>
    </div>
  );
};

export default PlayerStatusHud;
