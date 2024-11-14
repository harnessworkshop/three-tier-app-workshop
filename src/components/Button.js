const Button = ({ value }) => {
    return (
        <button className='button button--blue button--diagonal'>     
          <span className='button__text'>{value}</span>
        </button>
    );
}

export default Button;