import React, { useEffect, useState } from 'react';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faBell, faUser } from '@fortawesome/free-solid-svg-icons';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';

import styles from './styles/Header.module.css';
const Header = ({ email, hasRoom, roomName }) => {
  const [hasUnreadNotifications, setHasUnreadNotifications] = useState(false);
  const navigate = useNavigate();
  

  useEffect(() => {
    const fetchNotifications = async () => {
      try {
        // Using the correct endpoint for unread notifications
        const response = await axios.get(`https://7hm4udd9s2.execute-api.ca-central-1.amazonaws.com/dev/user/${email}/get-unread-notification`);
        
        // Assuming the endpoint directly returns unread notifications
        const unreadNotifications = response.data.Unread_Notification;
        
        // Check if there are any unread notifications
        setHasUnreadNotifications(unreadNotifications.length > 0);
      } catch (error) {
        console.error('Error fetching unread notifications:', error);
      }
    };
  
    if (email) {
      fetchNotifications();
    }
  }, [email]);

   // Function to handle user profile navigation
   const handleUserProfileClick = async () => {
    try {
      const response = await axios.get(
        `https://7hm4udd9s2.execute-api.ca-central-1.amazonaws.com/dev/user/${email}/find-roommate-page`
      );

      if (response.status === 200) {
        console.log('CALLED FIND ROOMMATE PAGE AND RETURNED 200');
        // User has a profile, navigate to the user profile page
        navigate('/user-profile', { state: { email, hasRoom } });
      }
    } catch (error) {
      if (error.response && error.response.status === 400) {
        // User does not have a profile, navigate to the incomplete profile page
        navigate('/incomplete-profile', { state: { email, hasRoom } });
      } else {
        console.error('Error checking user profile:', error);
      }
    }
  };

  

  return (
    <header className={styles.header}>
      <div className={styles.logo}>
        <img src="/logo2.png" alt="RoomHub Logo" onClick={() => navigate('/home', { state: { hasRoom, email } })}/>
      </div>
      <div className={styles.icons}>
        <div className={styles.notificationWrapper}>
          <FontAwesomeIcon 
            icon={faBell} 
            className={styles.icon} 
            onClick={() => navigate('/notifications', { state: { email, hasRoom, roomName } })}
          />
          {hasUnreadNotifications && <span className={styles.redDot}></span>}
        </div>
        <FontAwesomeIcon 
          icon={faUser}
          className={styles.icon}
          onClick={handleUserProfileClick}
        />
      </div>
    </header>
  );
};

export default Header;
