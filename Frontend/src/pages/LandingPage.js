import { useNavigate } from 'react-router-dom';
import styles from '../styles/LandingPage.module.css';


const LandingPage = () =>{
    const navigate = useNavigate();

    return (
      <div className={styles.landingContainer}>
        <div className={styles.overlay}></div>
        <div className={styles.content}>
          <img src="/logo2.png" alt="RoomHub Logo" className={styles.logo} />
          <h1 className={styles.heading}>Welcome To RoomHub</h1>
          <p className={styles.subheading}>Connecting people and spaces, seamlessly.</p>
          <button className={styles.loginButton} onClick={() => navigate('/login')}>Log In To Get Started</button>
        </div>
      </div>
    );
}

export default LandingPage;