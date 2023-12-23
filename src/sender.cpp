// Copyright (C) 2017 The Qt Company Ltd.
// BSD-3-Clause

#include <QtNetwork>
#include <QtCore>
#include <QDebug>

#include "sender.h"

Sender::Sender()
{

//! [0]
    udpSocket = new QUdpSocket(this);
//! [0]
    qDebug() << " Constructor test" << mySipadd << mySport;

}

void Sender::startSender()
{
    qDebug() << " testi2" ;
    //startBroadcasting();
    //broadcastDatagram();
}

void Sender::sendPosition() //sendInitialPosition
{
    //timer.start(1000);
    qDebug() << "Send initial position" << myCmove;
    //QByteArray datagram = "INIT," + mySipadd.toUtf8()  + "," + myCmove.toUtf8();
    QByteArray datagram = myCmove.toUtf8();
    udpSocket->writeDatagram(datagram, QHostAddress::Broadcast, 45454);
}

void Sender::broadcastDatagram() // sendMove
{
    qDebug() << "start broadcasting" << mySipadd << mySport;
    //QByteArray datagram = "MOVE," + mySipadd.toUtf8()  + "," + QByteArray::number(messageNo);
    QByteArray datagram = mySipadd.toUtf8();
    udpSocket->writeDatagram(datagram, QHostAddress::Broadcast, 45454);
//! [1]
    ++messageNo;
}
