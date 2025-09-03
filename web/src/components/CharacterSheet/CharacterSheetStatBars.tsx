import React, { useState } from "react";
import { useNuiEvent } from "../../hooks/useNuiEvent";
import { PlayerStats } from "../../types/playerhud";
import { IconConfigs } from "../../types/iconconfigs";

const CharacterSheetStatBars: React.FC = () => {
    const [health, setHealth] = useState<number>(100);
    const [armor, setArmor] = useState<number>(0);
    const [hunger, setHunger] = useState<number>(100);
    const [thirst, setThirst] = useState<number>(100);
    const [icons, setIcons] = useState<IconConfigs>({
        healthIcon: 'fas fa-heart',
        deadIcon: '',
        staminaIcon: 'fas fa-person-running',
        foodIcon: 'fas fa-drumstick-bite',
        waterIcon: 'fas fa-bottle-water',
        stressIcon: '',
        fuelIcon: '',
        seatbeltIcon: ''
    });

    useNuiEvent<Partial<PlayerStats & { armor?: number }>>("updatePlayerStats", (data) => {
        setHealth((prev) => typeof data.health === "number" ? Math.max(0, data.health) : prev);
        setArmor((prev) => typeof data.armor === "number" ? Math.max(0, Math.min(100, data.armor)) : prev);
        setHunger((prev) => typeof data.hunger === "number" ? data.hunger : prev);
        setThirst((prev) => typeof data.thirst === "number" ? data.thirst : prev);
    });

    useNuiEvent<IconConfigs>("setIcons", (iconConfigs) => {
        setIcons(prev => ({ ...prev, ...iconConfigs }));
    });

    return (
            <div className="rounded-lg w-1/3 p-5 flex justify-center items-center min-h-[70vh] ml-[59vh]">
                <div className="grid grid-cols-2 grid-rows-2 gap-x-[24vh] gap-y-4">
                {/* Health */}
                <div className="flex items-center">
                    <i className={`${icons.healthIcon} text-white text-xl mr-2`} />
                    <div className="relative w-40 h-7 rounded-md overflow-hidden shadow">
                        <div className="absolute inset-0 bg-green-600" style={{ width: `${health}%` }}></div>
                        <span className="absolute left-2 top-1/2 -translate-y-1/2 text-white font-bold text-md drop-shadow">{health}</span>
                    </div>
                </div>
                {/* Food */}
                <div className="flex items-center">
                    <i className={`${icons.foodIcon} text-white text-xl mr-2`} />
                    <div className="relative w-40 h-7 rounded-md overflow-hidden shadow">
                        <div className="absolute inset-0 bg-yellow-400" style={{ width: `${Math.round(hunger)}%` }}></div>
                        <span className="absolute left-2 top-1/2 -translate-y-1/2 text-white font-bold text-md drop-shadow">{Math.round(hunger)}</span>
                    </div>
                </div>
                {/* Armour */}
                <div className="flex items-center">
                    <i className={`fas fa-shield-alt text-white text-xl mr-2`} />
                    <div className="relative w-40 h-7 rounded-md overflow-hidden shadow">
                        <div className="absolute inset-0 bg-blue-900" style={{ width: `${armor}%` }}></div>
                        <span className="absolute left-2 top-1/2 -translate-y-1/2 text-white font-bold text-md drop-shadow">{armor}</span>
                    </div>
                </div>
                {/* Water */}
                <div className="flex items-center">
                    <i className={`${icons.waterIcon} text-white text-xl mr-3`} />
                    <div className="relative w-40 h-7 ml-1 rounded-md overflow-hidden shadow">
                        <div className="absolute inset-0 bg-cyan-400" style={{ width: `${Math.round(thirst)}%` }}></div>
                        <span className="absolute left-2 top-1/2 -translate-y-1/2 text-white font-bold text-md drop-shadow">{Math.round(thirst)}</span>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default CharacterSheetStatBars;