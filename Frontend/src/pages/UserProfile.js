import React, { useEffect } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import styles from '../styles/HomePage.module.css'; 

const UserProfile = ({ user, signOut }) => {
  const location = useLocation();
  const email = user?.signInDetails?.loginId;
  const navigate = useNavigate();
  const hasRoom = location.state?.hasRoom;

  return (
    <div className={styles.container}>
      <header className={styles.header}>
        <div className={styles.logo}>
          <img src="/logo2.png" alt="RoomHub Logo" />
        </div>
      </header>

        <h1 className={styles.title}>User Profile for {email}</h1>
        <button className={styles.logout} onClick={() => {
          signOut(); // This will log the user out of Cognito
          navigate('/'); // Then redirect to the landing page
        }}>Log Out</button>
        <button className={styles.logout} onClick={() => navigate('/home', { state: { email, hasRoom } })}>Back to Home</button>
    </div>
  );
};

export default UserProfile;
