import React, { useState } from "react";
import OxygenFill from "./OxygenFill";
import Mugshot from "./Mugshot";
import ArmorIcon from "./ArmorIcon";
import { useNuiEvent } from "../../hooks/useNuiEvent";

const PlayerIconContainer: React.FC = () => {
  const [mugshot, setMugshot] = useState<string | null>(null);
  const [armor, setArmor] = useState<number>(100);
  const [oxygen, setOxygen] = useState<number>(100);

  useNuiEvent<string>("setPlayerMugshot", setMugshot);
  useNuiEvent<Partial<{ armor: number; oxygen: number }>>("updatePlayerStats", (data) => {
    if (typeof data.armor === "number") setArmor(data.armor);
    if (typeof data.oxygen === "number") setOxygen(data.oxygen);
  });

  return (
    <div className="relative" style={{ width: 96, height: 96 }}>
      <Mugshot mugshot={mugshot} />
      <ArmorIcon armor={armor} />
      <OxygenFill oxygen={oxygen} />
    </div>
  );
};

export default PlayerIconContainer;
