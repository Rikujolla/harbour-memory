// Copyright (C) 2017 The Qt Company Ltd.
// BSD-3-Clause

#ifndef SENDER_H
#define SENDER_H
#include <QObject>

#include <QTimer>

QT_BEGIN_NAMESPACE
class QLabel;
class QPushButton;
class QUdpSocket;
QT_END_NAMESPACE

class Sender : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString sipadd READ sipadd WRITE setSipadd NOTIFY sipaddChanged)
    Q_PROPERTY(int sport READ sport WRITE setSport NOTIFY sportChanged)
    Q_PROPERTY(QString cmove READ cmove WRITE setCmove NOTIFY cmoveChanged)

public:
    explicit Sender();
    QString sipadd(){return mySipadd;}
    void setSipadd(QString tee1){
      mySipadd = tee1;
      sipaddChanged(mySipadd);
    }
    int sport(){return mySport;}
    void setSport(int tee2){
      mySport = tee2;
      sportChanged(mySport);
    }
    QString cmove(){return myCmove;}
    void setCmove(QString tee3){
      myCmove = tee3;
      cmoveChanged(myCmove);
    }
    Q_INVOKABLE void startSender();
    Q_INVOKABLE void sendPosition();
    Q_INVOKABLE void broadcastDatagram();

signals:
    void sipaddChanged(QString tee1);
    void sportChanged(int tee2);
    void cmoveChanged(QString tee3);

private slots:
    //void startBroadcasting();
    //void broadcastDatagram();

private:
    QLabel *statusLabel = nullptr;
    QPushButton *startButton = nullptr;
    QUdpSocket *udpSocket = nullptr;
    QTimer timer;
    int messageNo = 1;
    QString mySipadd;
    int mySport;
    QString myCmove;
};

#endif
