import React, { useEffect, useState } from 'react';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faBell, faUser } from '@fortawesome/free-solid-svg-icons';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';

import styles from './styles/Header.module.css';
const Header = ({ email, hasRoom, roomName }) => {
  const [hasUnreadNotifications, setHasUnreadNotifications] = useState(false);
  const navigate = useNavigate();

  //Fetch notifications to check if there are unread ones
  useEffect(() => {
    const fetchNotifications = async () => {
      try {
        
        const response = await axios.get(`https://7hm4udd9s2.execute-api.ca-central-1.amazonaws.com/dev/user/${email}/get-notification`);
        
        
        // Check if any notifications have status 'unread'
        const notifications = response.data.All_Notifications; 
        const hasUnread = notifications.length > 0;
        setHasUnreadNotifications(hasUnread);

      } catch (error) {
        console.error('Error fetching notifications:', error);
      }
    };

    if (email) {
      fetchNotifications();
    }
  }, [email]);

  return (
    <header className={styles.header}>
      <div className={styles.logo}>
        <img src="/logo2.png" alt="RoomHub Logo" />
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
          onClick={() => navigate('/user-profile', { state: { email, hasRoom } })}
        />
      </div>
    </header>
  );
};

export default Header;
