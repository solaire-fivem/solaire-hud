import React, { useState } from "react";
import { useNuiEvent } from "../../hooks/useNuiEvent";

const PlayerName: React.FC = () => {
  const [playerName, setPlayerName] = useState<string>("Player Name");
  useNuiEvent<string>("setPlayerName", setPlayerName);
  return (
    <div className="flex justify-center">
      <span className="font-cinzel text-white drop-shadow">
        {playerName.trim().length > 24
          ? `${playerName.trim().substring(0, 24)}...`
          : playerName.trim()}
      </span>
    </div>
  );
};

export default PlayerName;
