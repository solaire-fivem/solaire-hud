import PlayerName from "../PlayerHud/PlayerName"

const PlayerNameHeader: React.FC = () => {
    return (
        <div className="fixed inset-0 flex items-center justify-center mb-[40rem] z-50 pointer-events-none" >
            <div className="bg-gray-900 bg-opacity-85 rounded-lg p-1 pl-2 pr-2 w-1/4 hud-glow flex items-center justify-center">
                <span className="w-full text-center text-3xl font-serif font-extrabold text-white drop-shadow-lg">
                    <PlayerName />
                </span>
            </div>
            <style>{`
                .hud-glow {
                  box-shadow: 0 0 2px 2px #ab8e2cff, 0 0 16px 2px #ab8e2c88, 0 0 8px 1px #111827;
                }
            `}</style>
        </div>
    );
};

export default PlayerNameHeader;