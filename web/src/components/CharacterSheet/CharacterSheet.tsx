import PlayerNameHeader from "./PlayerNameHeader"
import { CharacterSheetProps } from "../../types/charactersheet";
import CharacterSheetStatBars from "./CharacterSheetStatBars";

const CharacterSheet: React.FC<CharacterSheetProps> = ({ characterSheetVisible }) => {
    if (!characterSheetVisible) return null;
    return (
        <div>
            <PlayerNameHeader />
            <CharacterSheetStatBars />
        </div>
    );
};

export default CharacterSheet;