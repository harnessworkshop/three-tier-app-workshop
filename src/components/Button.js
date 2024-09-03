import { useTrack } from '@splitsoftware/splitio-react';

const Button = ({ value }) => {
    const track = useTrack();

    const handleClick = () => {
        console.log("handling click");
        track('user', 'sign_up');
    }

    return (
        <button className='button button--blue button--diagonal' onClick={handleClick}>     
          <span className='button__text'>{value}</span>
        </button>
    );
}

export default Button;