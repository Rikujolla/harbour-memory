// Copyright (C) 2017 The Qt Company Ltd.
// BSD-3-Clause

#ifndef RECEIVER_H
#define RECEIVER_H

#include <QObject>


QT_BEGIN_NAMESPACE
class QUdpSocket;
QT_END_NAMESPACE

class Receiver : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString rmove READ rmove WRITE setRmove NOTIFY rmoveChanged)

public:
    explicit Receiver();
    QString rmove(){return myRmove;}
    void setRmove(QString tee3){
        myRmove = tee3;
        rmoveChanged(myRmove);
    }

    //    Q_INVOKABLE void startReceiver();
    Q_INVOKABLE void processPendingDatagrams();
signals:
    void rmoveChanged(QString tee3);

private slots:
    //void processPendingDatagrams();

private:
    QUdpSocket *udpSocket = nullptr;
    QString myRmove;

};

#endif
